#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#   Installs a .pkg installer on the target device
#
# DESCRIPTION
#   This remediation script will install a application on the 
#    target device after it has been downloaded from the
#    Automox server.
#
#   Note: this will work with both .pkg installers and apps provided
#   in dmg images. If the installer is a .pkg in a dmg, then
#   copy it out of the dmg and upload it to Vicarius.
#
#    To find the full name of the application, find an installed
#    version in your Applications folder, right click on it and
#    select "Get Info". Under the "Name & Extension:" section you'll
#    see the full name of the application and you can copy it to paste
#    into the script.
#
#    To find the name of the installer, right click on it and select
#    "Get Info". Under the "Name & Extension:" section you'll see the
#    full name of the application and you can copy it to paste into
#    the script.
#
#    To find the name of the mounted volume when using a DMG, double
#    click on the DMG to mount it. Open a new Finder window and you'll
#    see the name of the mounted volume in the sidebar. Remember to
#    unmount the volume (by dragging it to the trash) before you begin
#    testing the script.
#
# USAGE
#   ./install_pkg.sh
#
#================================================================
# END_OF_HEADER
#================================================================

# Let's set some variables
installer="installer_name" # make sure there's a .pkg or .dmg at the end. Note: this is case sensitive.
app="app_name" # app name in the image to be copied. make sure it has .app on the end.
mountPath="/Volumes/mounted_dmg" # replace "mounted_dmg" with the name of the mounted volume. only used for dmgs.

# First we should check if the installer variable is set correctly
if [[ "$installer" != *".pkg" && "$installer" != *".dmg" ]]
    then echo "The installer doesn't seem to be the appropriate type. Please edit remediation.sh to resolve."
	     exit
fi

# This function installs the app from the .pkg file
pkg_install() {
    installer -pkg "$installer" -target / > /dev/null 2>&1
    if [ -d "/Applications/$app" ];
        then echo "$app has been successfully installed."
        else echo "$app was not successfully installed."
    fi

}

# This function installs the app from the DMG image
dmg_install() {
    yes | hdiutil attach -noverify -nobrowse "$installer" > /dev/null 2>&1
    cp -r "$mountPath/$app" "/Applications/"
    hdiutil detach "$mountPath" > /dev/null 2>&1
    if [ -d "/Applications/$app" ];
        then echo "$app has been successfully installed."
        else echo "$app was not successfully installed."
    fi

}

# This checks to see if the installer is a .pkg file and installs it. If it isn't a .pkg, it installs from the DMG
if [[ "$installer" == *".pkg" ]]
    then pkg_install
    else dmg_install
fi