<#
    Register a Windows scheduled task for each active Revit MEP project.
    The task runs RFAutomator.exe with the project's automation text file every day at 1:00 AM.
#>

# Path to Newforma project list CLI
$nfProjectList = "C:\Users\acurrie\Documents\RFTools Files\RFAutomation\NFProjectList.exe"

# Path to RushForth Automator executable
$automatorExe = "C:\Users\acurrie\Documents\RFTools Files\RFAutomation\RFAutomator.exe"

# Folder containing automation text files
$automationDir = "C:\Users\acurrie\Documents\RFTools Files\RFAutomation\Scheduled Tasks"

if (-not (Test-Path $nfProjectList)) {
    Write-Error "NFProjectList not found at $nfProjectList"
    exit 1
}

if (-not (Test-Path $automatorExe)) {
    Write-Error "RFAutomator not found at $automatorExe"
    exit 1
}

$projects = & $nfProjectList -active -type MEP | Where-Object { $_ -ne "" }

if (-not $projects) {
    Write-Host "No active projects found."
    exit 0
}

foreach ($project in $projects) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($project)
    $txt = Join-Path $automationDir "RF Automator_${name}_Print Sheets.txt"
    if (-not (Test-Path $txt)) {
        Write-Warning "Automation file not found for $name"
        continue
    }

    $taskName = "RF Automator_${name}_Print Sheets"
    $action = New-ScheduledTaskAction -Execute $automatorExe -Argument "\"$txt\""
    $trigger = New-ScheduledTaskTrigger -Daily -At 1:00AM

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Force
    Write-Host "Scheduled task '$taskName' created to run $txt at 1:00 AM."
}
