<#
    Create a Windows scheduled task for each project listed in projects.txt.
    Paths are provided via 'userpaths.txt':
        PDF Output Folder: C:\Path\To\Output
        RushForth Automator EXE: C:\Path\To\RFAutomator.exe
        Scheduled Tasks Folder: C:\Path\To\ScheduledTasks
    Edit 'projects.txt' to define your projects.
#>

$pathFile     = Join-Path $PSScriptRoot 'userpaths.txt'
$projectsFile = Join-Path $PSScriptRoot 'projects.txt'

if (-not (Test-Path $pathFile)) { throw 'userpaths.txt not found.' }
if (-not (Test-Path $projectsFile)) { throw 'projects.txt not found.' }

$pathMap = @{}
Get-Content $pathFile | ForEach-Object {
    if ($_ -match '^\s*([^:]+)\s*:\s*(.+)$') {
        $pathMap[$matches[1].Trim()] = $matches[2].Trim()
    }
}
function Get-UserPath([string]$key) {
    if ($pathMap.ContainsKey($key)) { return $pathMap[$key] }
    throw "Path '$key' missing from userpaths.txt"
}

$automatorExe = Get-UserPath 'RushForth Automator EXE'
$automationDir = Get-UserPath 'Scheduled Tasks Folder'
$pdfOutput = Get-UserPath 'PDF Output Folder'

if (-not (Test-Path $automatorExe)) { throw "RFAutomator not found at $automatorExe" }
if (-not (Test-Path $automationDir)) { throw "Automation directory not found at $automationDir" }

$projectLines = Get-Content $projectsFile | Where-Object { $_.Trim() -ne '' -and -not $_.Trim().StartsWith('#') }
if (-not $projectLines) { Write-Host 'No projects listed.'; return }

foreach ($line in $projectLines) {
    $projectName = $null
    if ($line -like '*Autodesk Docs*') {
        $tokens = $line -split '\s+'
        $rvtName = $tokens[0]
        $projectName = [System.IO.Path]::GetFileNameWithoutExtension($rvtName)
    } else {
        $projectDir = $line.Trim()
        $searchPath = Join-Path $projectDir '03 - Design\Revit PME Drawings'
        $rvtFile = Get-ChildItem -Path $searchPath -Filter '*.rvt' -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match '(?i)mech' } | Select-Object -First 1
        if (-not $rvtFile) { Write-Warning "No mech Revit file found in $projectDir"; continue }
        $projectName = $rvtFile.BaseName
    }

    $txt = Join-Path $automationDir "RF Automator_${projectName}_Print Sheets.txt"
    if (-not (Test-Path $txt)) { Write-Warning "Automation file not found for $projectName"; continue }

    $content = Get-Content $txt -Raw
    $pdfPath = Join-Path $pdfOutput "${projectName}.pdf"
    $updated = $content -replace '"[^" ]*?\.pdf"', '"' + $pdfPath + '"'
    if ($updated -ne $content) { Set-Content $txt $updated }

    $taskName = "RF Automator_${projectName}_Print Sheets"
    $action   = New-ScheduledTaskAction -Execute $automatorExe -Argument "\"$txt\""
    $trigger  = New-ScheduledTaskTrigger -Daily -At 1:00AM

    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Force
    Write-Host "Scheduled task '$taskName' created to run $txt at 1:00 AM."
}
