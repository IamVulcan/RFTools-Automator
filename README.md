# RFTools Automator Print Automation

This repository contains PowerShell scripts to automate printing PDF sets for active Revit MEP projects. `NFProjectList.exe` is used to discover active projects and each project has its own RushForth Automator (`RFAutomator.exe`) print automation saved as a **.txt** file.

## Scripts

- **print_mep_sheets.ps1** – Queries Newforma for active projects and runs each project's automation file to immediately print sheets to PDF.
- **schedule_prints.ps1** – Creates a Windows scheduled task for every active project so its automation file runs daily at **1:00 AM**.

## Setup

1. Copy `userpaths.txt` and edit each path so it matches your environment. Example entries:

   ```
   PDF Output Folder: C:\PDF\Output
   RushForth Automator EXE: C:\Tools\RFAutomator.exe
   Newforma CLI: C:\Tools\NFProjectList.exe
   Scheduled Tasks Folder: C:\Automation\ScheduledTasks
   Project Folder: C:\RevitProjects
   ```

   `print_mep_sheets.ps1` and `schedule_prints.ps1` read these paths at runtime. The **PDF Output Folder** value is written into each automation `.txt` file before printing.
2. Ensure each project has a print automation file named `RF Automator_<PROJECT_NAME>_Print Sheets.txt` in the folder specified by `Scheduled Tasks Folder:`.

## Scheduling

Run `schedule_prints.ps1` once from an elevated PowerShell session to create the individual tasks. Each task is named `RF Automator_<PROJECT_NAME>_Print Sheets` and runs its automation file daily at **1:00 AM**.
