Copy-Item "\\sysvollocation\MitelConnect_213.100.5477.0.exe" -Destination "C:\temp"
Copy-Item "\\sysvollocation\install.bat" -Destination "C:\temp"

$action = New-ScheduledTaskAction -Execute "C:/temp/install.bat" -Argument "/S"
$trigger =  New-ScheduledTaskTrigger -AtLogOn -RandomDelay 
$user = "NT AUTHORITY\SYSTEM"
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Mitel Connect" -Description "Mitel Update - Runs when user logs on, and under SYSTEM context" -User $user -RunLevel Highest -Force
