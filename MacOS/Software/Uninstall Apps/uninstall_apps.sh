#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#    Enforces uninstalls of a specific application on a macOS device
#
# DESCRIPTION
#    
#    This remediation script will uninstall the selected application in the set variable appnameon line 31.
#    This has been tested on macOS Catalina 10.15.7
#
# USAGE
#   ./uninstall_apps.sh
#   You will need to set the appname variable to the application name of your choosing. This is on line 31 of this script.
# 
#================================================================
# END_OF_HEADER
#================================================================

#########################
appname=Skype
#########################

#Remove the applicatiomn from the device
rm -rf /Applications/$appname.app 2> /tmp/uninstallerror.log

#exit with 0 if uninstall is successful
#exit with 1 if uninstall fails
if [ -s /tmp/uninstallerror.log ]; then
        exit 1
else
        exit 0
fi