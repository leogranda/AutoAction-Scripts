#  SYNOPSIS
#   Installs latest Zoom pkg for Mac if not already installed.
#
#  DESCRIPTION
#   This worklet pulls the latest Zoom pkg for Mac and installs it onto the user's system. It will also read out the version that gets installed, to ensure you're getting the latest build.
#   The Worklet below cURLs the pkg from Zoom, moves it to tmp, installs it, then removes the downloaded pkg. A task to auto-kill Zoom is included to not disturb the user.
#   
#
#  USAGE
#    ./latest_zoom_installer.sh
