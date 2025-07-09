<#
    PowerShell script to immediately print PDF sets for all active Revit MEP projects.
    Place a file named 'userpaths.txt' in the same folder as this script with entries like:
        PDF Output Folder: C:\Path\To\Output
        RushForth Automator EXE: C:\Path\To\RFAutomator.exe
        Newforma CLI: C:\Path\To\NFProjectList.exe
        Scheduled Tasks Folder: C:\Path\To\ScheduledTasks
        Project Folder: C:\Path\To\Projects
    Replace the example paths with your own local paths. The PDF Output Folder path
    is used to overwrite the output location in each automation text file before
    printing.
#>

$pathFile = Join-Path $PSScriptRoot 'userpaths.txt'
if (-not (Test-Path $pathFile)) {
    throw "userpaths.txt not found. Please create it with your paths."
}

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

$nfProjectList = Get-UserPath 'Newforma CLI'
$automatorExe  = Get-UserPath 'RushForth Automator EXE'
$automationDir  = Get-UserPath 'Scheduled Tasks Folder'
$pdfOutput      = Get-UserPath 'PDF Output Folder'

if (-not (Test-Path $nfProjectList)) { throw "NFProjectList not found at $nfProjectList" }
if (-not (Test-Path $automatorExe)) { throw "RFAutomator not found at $automatorExe" }
if (-not (Test-Path $automationDir))  { throw "Automation directory not found at $automationDir" }

$projects = & $nfProjectList -active -type MEP | Where-Object { $_ -ne '' }
if (-not $projects) { Write-Host 'No active projects found.'; return }

foreach ($project in $projects) {
    $name = [System.IO.Path]::GetFileNameWithoutExtension($project)
    $txt  = Join-Path $automationDir "RF Automator_${name}_Print Sheets.txt"

    if (-not (Test-Path $txt)) {
        Write-Warning "Automation file not found for $name"
        continue
    }

    # ensure PDF output path matches user preference
    $content = Get-Content $txt -Raw
    $pdfPath = Join-Path $pdfOutput ("${name}.pdf")
    $updated = $content -replace '"[^" ]*?\.pdf"', '"' + $pdfPath + '"'
    if ($updated -ne $content) { Set-Content $txt $updated }

    Write-Host "Printing sheets for $name"
    Start-Process -FilePath $automatorExe -ArgumentList "\"$txt\"" -Wait
}

Write-Host 'Print automation complete.'
