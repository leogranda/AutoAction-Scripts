ntpCheck=$(systemsetup -getusingnetworktime)
ntpServerCheck=$(systemsetup -getnetworktimeserver)
result="On"
ntpServer="time.apple.com" # If you would like to use a specific NTP server, it can be set here. The Default is time.apple.com

if [[ "${ntpCheck}" == "${result}" ]]; then
echo "Set date and time automatically is enabled. Skipping."
else
echo "Set date and time automatically isn't enabled. Enabling."
systemsetup -setusingnetworktime on
fi

if [[ "${ntpServerCheck}" == "${ntpServer}" ]]; then
echo "NTP server is set to ${ntpServer}. Skipping."
else
echo "NTP server isn't set to ${ntpServer}. Setting now."
systemsetup -setnetworktimeserver "${ntpServer}"
fi

exit