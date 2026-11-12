[CmdletBinding()]
param(
 [string]$ProjectName="Untitled Episode",
 [string]$Destination=(Join-Path $HOME "UNKNXWN-Projects")
)
$ErrorActionPreference="Stop"
$safeName=($ProjectName -replace '[<>:"/\\|?*]','').Trim()
$safeName=($safeName -replace '\s+','-')
if ([string]::IsNullOrWhiteSpace($safeName)) { throw "ProjectName must contain at least one valid character." }
if (-not (Test-Path -LiteralPath $Destination)) { New-Item -ItemType Directory -Path $Destination -Force | Out-Null }
$projectPath=Join-Path $Destination $safeName
if (Test-Path -LiteralPath $projectPath) { throw "A project already exists at '$projectPath'. Choose another name or destination. Existing work was not changed." }
$folders=@("01-Development\Scripts","01-Development\Storyboards","02-World\Characters","02-World\Locations","02-World\Props","03-Production\Shots","03-Production\Audio","03-Production\References","04-Post\Renders","04-Post\Exports","05-ProjectData","Logs")
New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
foreach ($folder in $folders) { New-Item -ItemType Directory -Path (Join-Path $projectPath $folder) -Force | Out-Null }
$projectId=[guid]::NewGuid().ToString()
$project=[ordered]@{
 schemaVersion="1.0.0"; projectId=$projectId; title=$ProjectName; studio="UNKNXWN Studios"; createdAtUtc=[DateTime]::UtcNow.ToString("o"); status="development"
 episode=[ordered]@{ number=1; title="Episode 01"; targetDurationSeconds=240; frameRate=24; resolution="1920x1080" }
 continuity=[ordered]@{ characters=@(); locations=@(); wardrobeSets=@(); props=@() }; shots=@()
 media=[ordered]@{ source="03-Production"; renders="04-Post/Renders"; exports="04-Post/Exports" }
}
$project | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath (Join-Path $projectPath "05-ProjectData\project.json") -Encoding UTF8
$readme=@"
# $ProjectName

UNKNXWN Studios local production project.

## Structure
- 01-Development: scripts and storyboards
- 02-World: character, location, prop and continuity references
- 03-Production: shot plans, audio and source references
- 04-Post: renders and final exports
- 05-ProjectData: structured project metadata
- Logs: diagnostic and production logs

Project ID: $projectId

This is a project scaffold. It does not generate images, video, voices, or download AI models.
"@
$readme | Set-Content -LiteralPath (Join-Path $projectPath "README.md") -Encoding UTF8
Write-Host ""; Write-Host "UNKNXWN project created." -ForegroundColor Green
Write-Host "Location: $projectPath"; Write-Host "Project ID: $projectId"; Write-Host "No existing files were overwritten."