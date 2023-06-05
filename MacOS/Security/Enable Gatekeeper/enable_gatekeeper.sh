#!/bin/bash

#================================================================
# HEADER
#================================================================
# SYNOPSIS
#    Enables Gatekeeper on MacOS
#
# DESCRIPTION
#    
#    Worklet will enable Gatekeeper fo all users on the device.
#
# USAGE
#    ./enable_gatekeeper.sh
# 
#================================================================
# END_OF_HEADER
#================================================================

# enable gatekeeper for all users
spctl --master-enable

# did we succeed?
exit $?