# M001 Windows quick start

These first Windows utilities use built-in Windows PowerShell. Python is not required. They do not install software, download model weights, or claim that AI generation is ready.

## 1. Get the project

Download or clone this repository to a folder you control. Keep it outside Program Files so project files remain writable.

## 2. Run the hardware check

Open windows\Start-UNKNXWN-Diagnostics.cmd. It writes a JSON report to:

%USERPROFILE%\UNKNXWN-diagnostic.json

The report checks Windows, CPU, system memory, display adapters, available NVIDIA telemetry, C: drive capacity, and common runtime commands. Missing tools are reported as not installed, not treated as fatal.

The script itself does not request administrator elevation.

## 3. Create a project

Open windows\Create-UNKNXWN-Project.cmd, enter a project name, and the scaffold is created under:

%USERPROFILE%\UNKNXWN-Projects

To choose another location or run without prompts:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\windows\New-UNKNXWNProject.ps1 -ProjectName "Pilot Episode" -Destination "D:\UNKNXWN-Projects"

The bootstrapper refuses to overwrite an existing project folder.

## Current M001 boundary

This milestone establishes environment discovery and a stable production folder/project schema. It is not the one-file EXE installer, and it does not yet render AI scenes. The next milestones add backend detection and explicit, user-approved installation/model-download flows. A real Windows machine test is still required before calling this production-ready.