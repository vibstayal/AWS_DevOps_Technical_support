$BatFile = "C:\DeleteFile.Bat"
If (Test-Path $BatFile) { Del $BatFile }
$ScriptLine ='forfiles -p "C:\DataScopeDownload" -s -m *.* /D -2 /C "cmd /c del @path"', 
'forfiles -p "C:\FeedData" -s -m *.* /D -7 /C "cmd /c del @path"'
Set-Content -Path $BatFile -Value $ScriptLine -Encoding ASCII

$action = New-ScheduledTaskAction -Execute 'C:\DeleteFile.Bat' `

$trigger =  New-ScheduledTaskTrigger -Weekly -At 7:00am -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday

get-scheduledtask -taskname "DeleteFile" | Unregister-ScheduledTask -Confirm:$false

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DeleteFile" -Description "Delete file from folders" -User "gisysservice" -Password "RnR@ftse" -force