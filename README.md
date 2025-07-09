# RFTools Automator Print Automation

This repository contains PowerShell scripts to automate printing PDF sets for active Revit MEP projects. The workflow assumes that Newforma is used to manage active projects and that RushForth Automator for Revit is installed.

## Scripts

- **print_mep_sheets.ps1** – Queries Newforma for active projects and invokes RushForth Automator to run a saved automation that prints sheets to PDF.
- **schedule_prints.ps1** – Registers a daily scheduled task at 1:00 AM that calls `print_mep_sheets.ps1`.

### Setup

1. Update the paths to `NFProjectList.exe`, `RFAutomator.exe`, and the automation XML within `print_mep_sheets.ps1` to match your environment.
2. Use RushForth Automator's UI to create a print sheets automation and save it as `PrintSheets.xml` or another path you specify in the script.

### Scheduling

Run `schedule_prints.ps1` once from an elevated PowerShell session to create the scheduled task. The task is named **RFTools Print MEP Sheets** and will execute `print_mep_sheets.ps1` every day at **1:00 AM**.
