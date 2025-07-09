# PowerShell script to register a scheduled task that runs print_mep_sheets.ps1 daily at 1:00 AM

$taskName = "RFTools Print MEP Sheets"
$scriptPath = Join-Path $PSScriptRoot "print_mep_sheets.ps1"

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At 1:00AM
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force

Write-Host "Scheduled task '$taskName' created to run $scriptPath daily at 1:00 AM."
