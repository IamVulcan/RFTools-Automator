# RFTools Automator Print Automation

This repository contains PowerShell scripts to automate printing PDF sets for active Revit MEP projects using RushForth Automator.

## Scripts

- **print_mep_sheets.ps1** – Reads the project list from `projects.txt` and runs each project's automation file to immediately print sheets to PDF.
- **schedule_prints.ps1** – Creates a Windows scheduled task for every project so its automation file runs daily at **1:00 AM**.

## Setup

1. Edit `userpaths.txt` and set the paths for your environment. Example:

   ```
   PDF Output Folder: C:\PDF\Output
   RushForth Automator EXE: C:\Tools\RFAutomator.exe
   Scheduled Tasks Folder: C:\Automation\ScheduledTasks
   ```

   These scripts use the paths at runtime and overwrite the PDF location in each automation `.txt` file before printing.
2. List all of your projects in `projects.txt`. See the comments in that file for the required format. Each project must have a print automation file named `RF Automator_<PROJECT_NAME>_Print Sheets.txt` in the folder specified by `Scheduled Tasks Folder:`.

## Scheduling

Run `schedule_prints.ps1` once from an elevated PowerShell session to create the individual tasks. Each task is named `RF Automator_<PROJECT_NAME>_Print Sheets` and runs its automation file daily at **1:00 AM**.
