You'll need to find the exact process name to put in the procName variable. 
It's important that this is correct. To find the process name, install the software on your test device and make sure it's running. Open a terminal and run the command "ps -axc" (without the quotes) to get a list of all the processes running on your device.

Scroll through the list until you find the process name for the application. This list will be long so you can try using grep to narrow down the results, ie "ps -axc | grep -i zoom" if you were looking for the process for Zoom.