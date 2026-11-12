[CmdletBinding()]
param([string]$OutputPath = "")
$ErrorActionPreference = "Continue"
function Get-SafeValue {
    param([scriptblock]$Command, [string]$Fallback = "Unavailable")
    try { $value = & $Command; if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) { return $Fallback }; return $value }
    catch { return $Fallback }
}
function Get-CommandVersion {
    param([string]$Name, [string[]]$Arguments = @("--version"))
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) { return "Not installed" }
    try { $result = & $cmd.Source @Arguments 2>&1 | Select-Object -First 1; if ($result) { return [string]$result }; return "Installed (version unavailable)" }
    catch { return "Installed (version check failed)" }
}
$os = Get-SafeValue { (Get-CimInstance Win32_OperatingSystem).Caption }
$cpu = Get-SafeValue { (Get-CimInstance Win32_Processor | Select-Object -First 1).Name }
$ramGB = Get-SafeValue { [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1) }
$gpus = @()
try { $gpus = @(Get-CimInstance Win32_VideoController | ForEach-Object { [pscustomobject]@{ Name=$_.Name; DriverVersion=$_.DriverVersion; AdapterRAM_GB=if ($_.AdapterRAM) { [math]::Round($_.AdapterRAM / 1GB, 2) } else { $null } } }) } catch { $gpus = @() }
$nvidiaInfo = "Unavailable"
$nvidia = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($nvidia) { try { $nvidiaInfo = (& $nvidia.Source --query-gpu=name,memory.total,driver_version --format=csv,noheader 2>&1 | Out-String).Trim() } catch { $nvidiaInfo = "nvidia-smi found, query failed" } }
$drive = Get-SafeValue { $d=Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"; [pscustomobject]@{ Drive="C:"; FreeGB=[math]::Round($d.FreeSpace/1GB,1); SizeGB=[math]::Round($d.Size/1GB,1) } } $null
$report = [ordered]@{
 Product="UNKNXWN Studios"; DiagnosticVersion="0.1.0"; GeneratedAtUtc=[DateTime]::UtcNow.ToString("o")
 OperatingSystem=$os; Architecture=[System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
 PowerShell=$PSVersionTable.PSVersion.ToString(); CPU=$cpu; SystemRAM_GB=$ramGB; GPUs=$gpus; NvidiaSmi=$nvidiaInfo; CDrive=$drive
 Runtimes=[ordered]@{ Git=(Get-CommandVersion "git"); DotNet=(Get-CommandVersion "dotnet" @("--version")); FFmpeg=(Get-CommandVersion "ffmpeg"); Python=(Get-CommandVersion "python" @("--version")); Ollama=(Get-CommandVersion "ollama" @("--version")); Winget=(Get-CommandVersion "winget" @("--version")) }
 Notes=@("This diagnostic does not install software or download models.","GPU memory reported by Windows may be approximate; use NvidiaSmi when available.","No hardware is assumed. Backend compatibility is decided by later capability checks.")
}
$report | ConvertTo-Json -Depth 8
if (-not [string]::IsNullOrWhiteSpace($OutputPath)) {
 $parent=Split-Path -Parent $OutputPath
 if ($parent -and -not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
 $report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding UTF8
 Write-Host "Diagnostic saved to: $OutputPath" -ForegroundColor Green
}