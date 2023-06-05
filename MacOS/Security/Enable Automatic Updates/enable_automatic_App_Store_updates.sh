#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#   Enables automatic App Store app updates.
#
# DESCRIPTION
#   Automatically installing updates from the App Store helps
#   keep a computer patched and secure.
#
# USAGE
#   ./enable_automatic_App_Store_updates.sh
#
#
#================================================================
# END_OF_HEADER
#================================================================
# Let's set some variables!

updateCheck=$(defaults read /Library/Preferences/com.apple.commerce AutoUpdate)

if [[ "${updateCheck}" -eq 0 ]]; then
    echo "Automatic udpates for App Store apps is not enabled. Enabling now..."
    defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
else
    echo "Automatic udpates for App Store apps are already enabled."
fi

exit