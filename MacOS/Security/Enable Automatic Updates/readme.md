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