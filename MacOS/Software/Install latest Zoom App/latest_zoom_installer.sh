#================================================================
# HEADER
#================================================================
#  SYNOPSIS
#   Installs latest Zoom pkg for Mac if not already installed.
#
#  DESCRIPTION
#   This worklet pulls the latest Zoom pkg for Mac and installs it onto the user's system. It will also read out the version that gets installed, to ensure you're getting the latest build.
#   The Worklet below cURLs the pkg from Zoom, moves it to tmp, installs it, then removes the downloaded pkg. A task to auto-kill Zoom is included to not disturb the user.
#   
#
#  USAGE
#    ./install_latest_zoom.sh
#
#
#================================================================
# END_OF_HEADER
#================================================================

zoomURL="https://zoom.us/client/latest/Zoom.pkg"
appPkg="Zoom.pkg"
downloadLoc="/tmp/${appPkg}"
appPath="/Applications/zoom.us.app"
appVersion=$(mdls -name kMDItemVersion /Applications/zoom.us.app 2>&1 |awk -F '"' '{print $2}' | head -2)


if [[ -d "${appPath}" ]]; then
	echo "Zoom already installed, current app version is ${appVersion}"
	exit 0
else
	echo "Zoom Meetings does not exist, downloading and installing now"
	curl -L -o "${downloadLoc}" "${zoomURL}"
	echo "Installing Zoom now"
	installer -pkg "${downloadLoc}" -target /
	# The killall command below ensures Zoom does not pop-up on the users screen. Comment the line below out if you want that to happen.
	killall zoom.us
	# Cleans up pkg
	rm -r "${downloadLoc}"
fi

# Calls Zoom again to ensure it's installed
appPath="/Applications/zoom.us.app"
appVersion=$(mdls -name kMDItemVersion /Applications/zoom.us.app 2>&1 |awk -F '"' '{print $2}' | head -2)

if [[ -d "${appPath}" ]]; then
	echo "Zoom installed successfully, installed version is ${appVersion}"
else
	echo "Zoom not installed on the device"
fi

exit