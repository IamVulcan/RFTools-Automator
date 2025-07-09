<#
    PowerShell script to immediately print PDF sets for all active Revit MEP projects.
    Each project must have a corresponding automation text file in the format
    "RF Automator_<PROJECT_NAME>_Print Sheets.txt".
#>

# Path to Newforma project list CLI
$nfProjectList = "C:\\Users\\acurrie\\Documents\\RFTools Files\\RFAutomation\\NFProjectList.exe"

# Path to RushForth Automator executable
$automatorExe = "C:\\Users\\acurrie\\Documents\\RFTools Files\\RFAutomation\\RFAutomator.exe"

# Folder containing all automation text files
$automationDir = "C:\\Users\\acurrie\\Documents\\RFTools Files\\RFAutomation\\Scheduled Tasks"

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

if (-not (Test-Path $automatorExe)) {
    Write-Error "RFAutomator not found at $automatorExe"
    exit 1
}

foreach ($project in $projectPaths) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($project)
    $txt = Join-Path $automationDir "RF Automator_${name}_Print Sheets.txt"

    if (-not (Test-Path $txt)) {
        Write-Warning "Automation file not found for $name"
        continue
    }

    Write-Host "Printing sheets for $name"
    Start-Process -FilePath $automatorExe -ArgumentList "`"$txt`"" -Wait
}

Write-Host "Print automation complete."
