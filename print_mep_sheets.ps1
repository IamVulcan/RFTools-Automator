# PowerShell script to automate printing PDF sets for active Revit MEP projects
# Requires Newforma CLI and RushForth Automator for Revit.

# Path to Newforma project list CLI (update to your installation)
$nfProjectList = "C:\\Program Files\\Newforma\\NFProjectList.exe"

# Path to RushForth Automator executable
$automatorExe = "C:\\Program Files\\RushForth Tools\\Automator for Revit\\RFAutomator.exe"

# Saved automation file that performs the Print Sheets action
$automationFile = "C:\\Automations\\PrintSheets.xml"

# Query Newforma for active MEP projects
if (-not (Test-Path $nfProjectList)) {
    Write-Error "NFProjectList not found at $nfProjectList"
    exit 1
}
$projectPaths = & $nfProjectList -active -type MEP | Where-Object { $_ -ne "" }

if (-not $projectPaths) {
    Write-Host "No active projects found."
    exit 0
}

# Validate remaining paths
if (-not (Test-Path $automatorExe)) {
    Write-Error "RFAutomator not found at $automatorExe"
    exit 1
}
if (-not (Test-Path $automationFile)) {
    Write-Error "Automation file not found at $automationFile"
    exit 1
}

foreach ($project in $projectPaths) {
    Write-Host "Printing sheets for $project"
    Start-Process -FilePath $automatorExe -ArgumentList "-automation `"$automationFile`" -project `"$project`"" -Wait
}

Write-Host "Print automation complete."
