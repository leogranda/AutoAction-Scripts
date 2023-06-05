#!/bin/bash

#================================================================
# HEADER
#================================================================
#  SYNOPSIS
#    Installs Microsoft Office 365 on the target device
#
#  DESCRIPTION
#    This script checks to see if Office 365 is installed
#    on the target device and if it isn't, downloads it from
#    Microsoft's servers and installs it.
#
#    Note: this script is optional and to be used in the case where
#    you need the app to be reinstalled if it's uninstalled. Also,
#    the installer is over 8GB so it takes a while for the script to run.
#
#
#  USAGE
#    ./install_O365.sh
#
#================================================================
# END_OF_HEADER
#================================================================

# Let's set some variables
downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
pkg="Microsoft_Office_Installer.pkg"
downloadLoc="/tmp/$pkg"
app="/Applications/Microsoft Excel.app"

# If Offie isn't already installed, download the latest version and install.
if [ ! -d "$app" ]; then
    echo "Microsoft Office 365 isn't installed. Downloading the latest version."
    curl -L -o "$downloadLoc" "$downloadURL"
    echo "Installing the latest version of Microsoft Office 365."
    installer -pkg "$downloadLoc" -target /
    echo "Doing a bit of housecleaning. Deleting Microsoft Office 365 installer."
    rm -rf "$downloadLoc"
else
echo "Microsoft Office 365 is already installed. Skipping installation."

fi

exit