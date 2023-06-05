#!/bin/bash

#================================================================
# HEADER
#================================================================
#  SYNOPSIS
#    Enables automatic updates in Software Update
#
#  DESCRIPTION
#    This worklet changes preferences in Software Update to enable
#    automatic updates, downloading updates in the background as
#    well as making sure GateKeeper and XProtect are kept up to date.
#    It also checks the option to automatically install macOS updates.
#    This remediation script checks to see if any of these things are
#    disabled and enables them.
#
#
#  USAGE
#    ./enable_automatic_updates.sh
#
#================================================================
#  HISTORY
#    05/10/2021 : brillie : Script creation
#    03/21/2022 : mbauer : Validated on Monterey, Big Sur, M1
#
#================================================================
# END_OF_HEADER
#================================================================
# Let's set some variables

array=(AutomaticCheckEnabled AutomaticDownload ConfigDataInstall CriticalUpdateInstall AutomaticallyInstallMacOSUpdates)

for i in "${array[@]}"; do
    if [[ $(defaults read /Library/Preferences/com.apple.SoftwareUpdate "$i") -ne 1 ]]; then
        echo "$i is disabled. Enabling."
        defaults write /Library/Preferences/com.apple.SoftwareUpdate "$i" -bool true
    fi
done

exit