# RFTools Automator Print Automation

This repository contains PowerShell scripts to automate printing PDF sets for active Revit MEP projects.  `NFProjectList.exe` is used to discover active projects and each project has its own RushForth Automator (`RFAutomator.exe`) print automation saved as a **.txt** file.

## Scripts

- **print_mep_sheets.ps1** – Queries Newforma for active projects and invokes RushForth Automator to run a saved automation that prints sheets to PDF.
- **schedule_prints.ps1** – Creates an individual Windows scheduled task for every active project so that each one runs its corresponding automation file daily at **1:00 AM**.

### Setup

1. Update the paths to `NFProjectList.exe`, `RFAutomator.exe`, and the folder that stores the project automation **.txt** files in both scripts.
2. Each project must have a print automation file named `RF Automator_<PROJECT_NAME>_Print Sheets.txt` inside that folder. These can be created through the RushForth Automator UI.

### Scheduling

Run `schedule_prints.ps1` once from an elevated PowerShell session to register a separate scheduled task for every active project found in Newforma. Each task is named `RF Automator_<PROJECT_NAME>_Print Sheets` and runs its automation file daily at **1:00 AM**.
