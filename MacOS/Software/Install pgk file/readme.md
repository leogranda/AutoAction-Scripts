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