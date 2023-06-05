#!/bin/bash

#================================================================
# HEADER
#================================================================
#  SYNOPSIS
#    Disables Remote Login on the target device.
#
#  DESCRIPTION
#    Disabling Remote Login stops a malicious actor from remotely
#    connecting to a device using ssh.
#    
#
#
#  USAGE
#    ./disable_remote_login.sh
#
#================================================================
# END_OF_HEADER
#================================================================
# Let's set some variables!
remoteLogin=$(systemsetup -getremotelogin | awk '{print $3}')

if [[ ${remoteLogin} == "On" ]]; then
    echo "Remote Login is enabled. Disabling."
    systemsetup -f -setremotelogin off
else
    echo "Remote Login is disabled. Exiting"
    exit 0
fi