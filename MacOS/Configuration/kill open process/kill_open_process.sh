procName="zoom.us" # This is the proccess name that the script will search for to get the process ID.
procID=$(pgrep -i "${procName}") # This takes the process name and finds the process ID.
procTest=$(pgrep -il zoom | awk '{ print $2 }') # This checks to see if the process is actually running.


if [[ ! "${procTest}" == "${procName}" ]];
then
echo "The process ${procName} isn't running on this device. Exiting." && exit 0
else
kill "${procID}" && echo "Killing ${procName}."
fi