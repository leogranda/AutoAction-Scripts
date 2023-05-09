Restarts the Topia Service and provides logs of the status


powershell.exe -executionpolicy bypass -command .\Restart-Topia.ps1
powershell.exe -executionpolicy bypass -command "start-sleep -s 30"
powershell.exe -executionpolicy bypass -command "Get-eventlog -LogName Application -Source "topia" -newest 1 | Where-Object {$_.eventid -eq 10001} | Select-Object -property Time, Message "