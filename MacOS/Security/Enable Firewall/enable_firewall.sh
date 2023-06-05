#!/bin/bash

#================================================================
# HEADER
#================================================================
#  SYNOPSIS
#    Enables the built in firewall on the target device.
#
#  DESCRIPTION
#    A firewall minimizes the threat of unauthorized users from
#    gaining access to your system while connected to a network
#    or the Internet.
#
#
#  USAGE
#    ./enable_firewall.sh
#
#================================================================
# END_OF_HEADER
#================================================================
#Let's set some variables!
fwCheck=$(defaults read /Library/Preferences/com.apple.alf globalstate)

if [[ "${fwCheck}" -eq 0 ]]; then
    echo "Firewall is disabled on this device. Enabling."
    defaults write /Library/Preferences/com.apple.alf globalstate -int 1
else
    echo "Firewall is already enabled on this device. Exiting"
    exit 0
fi