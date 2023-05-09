function restart-topia() {
    $logOBJ = New-Object -TypeName pscustomobject
    $i = 0
    $null = start-job -name RestartTopia -scriptblock {start-sleep -s 5; get-service | ?{$_.name -eq "topia"} | Restart-Service}
    #get-service | ?{$_.name -eq "topia"} | Restart-Service 
    start-sleep -s 5
    if ((get-service | ?{$_.name -eq "topia"}).status -ne "Running") {
        try {
            get-service | ?{$_.name -eq "topia"} | Start-Service
        }
        Catch {
            Write-host "Unable to Start Topia Service"

            $logOBJ | Add-member -MemberType NoteProperty -Name "Topia Service" -value "Unable to Start Topia Service"
        
        }
     }
    $date = get-date
    $topiaStatus = get-service | ?{$_.name -eq "topia"}
    Write-host "Topia Service: " $topiaStatus.statusl
    Write-host "Time: " $date
    Write-host "EventLog: *******************"
    Get-eventlog -LogName Application -Source "topia" -Newest 2
    $restartLog = Get-eventlog -LogName Application -Source "topia" -Newest 2
    $logOBJ | Add-member -MemberType NoteProperty -Name "TopiaService" -value $topiaStatus.status
    $logOBJ | Add-member -MemberType NoteProperty -Name "Date" -value $date 
    $restartlogData = $restartLog | Format-Table | Out-String  
    $logOBJ | Add-member -MemberType NoteProperty -Name "RestartLog" -value $restartlogData
    return $logOBJ
    }
restart-topia