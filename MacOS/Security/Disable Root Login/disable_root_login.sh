#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#	Makes sure root login (at login window) is disabled.
#
# DESCRIPTION
#	Helps secure macOS by making sure users are unable to log in
#	at the login window as the root user.
#
# USAGE
#	./disable_root_login.sh
#
#================================================================
# END_OF_HEADER
#================================================================
# Let's set some variables!

rootTest=$(dscl . -read /Users/root AuthenticationAuthority 2>/dev/null)

if [[ -z "${rootTest}" ]]; then
    echo "Root login already disabled. Exiting..."
else
    echo "Root login enabled. Disabling..."
    dscl . -delete /Users/root AuthenticationAuthority
    dscl . -create /Users/root Password '*'
    dscl . -create /Users/root UserShell /usr/bin/false
fi

exit