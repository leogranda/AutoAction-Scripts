#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#    Upgrades the endpoint to the Ventura version of macOS
#
# DESCRIPTION
#    This script upgrades the endpoint to the Ventura version of macOS.
#
#    Note: M1 Macs require authentication by an admin with a secure
#    token, so this worklet opens the cached installer to prompt the
#    the end user to proceed with the upgrade process.
#    Intel Macs can still upgrade in a more automated fashion
#    with this worklet.
#
# REQUIREMENTS
#    macOS installer cached in Applications folder
#
# USAGE
#    ./remediation.sh
#
#================================================================
# IMPLEMENTATION
#    version         FAC-136 Update to Ventura 
#    author          Tim Lee, Ben Rillie, Kyle Gregg, Matt Bauer
#
#================================================================
#  HISTORY
#    02/10/2021 : tlee : Script creation
#    04/28/2021 : brillie : Added header and comments, removed MD5 check
#    02/28/2022 : mbauer : Incorporated Kyle's changes to support Monterey
#    03/11/2022 : mbauer : M1 support
#
#================================================================
# END OF HEADER
#================================================================

# Let's set some variables!

# macOSName is the name of the OS to be downloaded. Case sensitive,
# without the leading "macOS".
macOSName="Ventura"
installerPath="/Applications/Install macOS ${macOSName}.app"
dmgPath="/Applications/Install macOS ${macOSName}.app/Contents/SharedSupport/SharedSupport.dmg"
logPath="/var/log/${macOSName}Install.log"
# Update freeSpaceRequired with the amount required by Apple for the chosen OS.
freeSpaceRequired="26000000000"
enableNotifications="true"
notificationTimeoutSeconds=60 # max 600 seconds
notificationTitle="macOS ${macOSName} Upgrade"
notificationMessage="Your computer will reboot in 1 minute to complete the upgrade"
openLog="true"
# Determining OS version based on "Darwin Version"
# 22 = Ventura, 21 = Monterey, 20 = Big Sur, 19 = Catalina, 18 = Mojave, 17 = High Sierra
darwinVersion=$(uname -r | cut -d "." -f1)
# Capture logged in user
consoleUser=$(scutil <<<"show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }')
if [[ -n "${consoleUser}" ]]; then
    consoleUserGUI=$(dscl . read /Users/"${consoleUser}" UniqueID | awk '{print $2}')
fi

## FUNCTIONS #############################################

function errMessage() {
    echo "$1" >&2
}

## START ###########################################

# Check OS Version, set the number to match the desired version of macOS
if [[ "${darwinVersion}" -eq 22 ]]; then
    errMessage "macOS ${macOSName} already installed.  Skipping upgrade."
    exit 1
fi

# Check to make sure the installer is there before proceeding
if [[ ! -e "${dmgPath}" ]]; then
    errMessage "The macOS ${macOSName} installer is missing from this device. Please download the installer and try again."
    exit 1
fi

# Check AC Power
if ! grep -q "AC Power" <<<"$(pmset -g ps)"; then
    errMessage "AC Power not detected."
    exit 1
fi

# Check Free Space
diskPlist=$(diskutil info -plist /)
freeDisk=$(/usr/libexec/PlistBuddy -c "Print :APFSContainerFree" /dev/stdin <<<"$diskPlist")
if [[ ${freeDisk} -lt ${freeSpaceRequired} ]]; then
    errMessage "Not enough free disk space available"
    exit 1
fi

if [[ "$(arch)" != "arm64" ]]; then

    # Create Install Log
    if [[ ! -f "${logPath}" ]]; then
        touch "${logPath}"
    else
        echo "" >"${logPath}"
    fi

    # Open Log
    if [[ -n "$consoleUser" ]] && [[ "$openLog" == "true" ]]; then
        launchctl asuser "${consoleUserGUI}" open "${logPath}"
    fi

    # Run background process to signal end of prepare step
    caffeinate -dism &
    caffPid=$!

    # Initiate install

    "${installerPath}"/Contents/Resources/startosinstall --agreetolicense --rebootdelay ${notificationTimeoutSeconds} --pidtosignal ${caffPid} &>"${logPath}" &

    # Monitor background process to signal end of prepare step
    declare -i timeElapsed=0
    while [[ $timeElapsed -le 1800 ]] && ps -p ${caffPid} &>/dev/null; do
        sleep 1
        timeElapsed+=1
    done
    if [[ $timeElapsed -gt 1800 ]]; then
        errMessage "Installation timed out"
        exit 1
    fi

    # Close Console
    consolePID=$(pgrep "Console")
    if [[ -n ${consolePID} ]]; then
        kill "${consolePID}"
    fi

 
else
    echo "Apple Silicon Mac detected, launching Install macOS $macOSName for end user."
    launchctl asuser "${consoleUserGUI}" open -a "${installerPath}"
fi

exit
