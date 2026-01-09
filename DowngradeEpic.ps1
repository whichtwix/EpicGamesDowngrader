# This scripts downgrades the Epic Games version to the previous live one using the 3rd party client Legendary
# 1. Download Legendary
# 2. Install with the provided manifest
# 3. Create a small launch script for the game

if ([bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"))
{
    Write-Host -BackgroundColor red "Please run this script as a normal user, not as administrator"
    Read-Host
    exit
}

Write-Host -BackgroundColor red "Downloading Legendary, please wait..."

# Download Legendary
curl.exe -LO https://github.com/whichtwix/legendary/releases/latest/download/legendary.exe

# This gives Legendary access to the Epic account, this is needed to download the game
.\legendary auth --import

# we have to do this first so the base url can populate as even putting it as a argument later is not enough
.\legendary install 963137e4c29d4c79a81323b8fab03a40 --abort-if-any-installed

Invoke-WebRequest -Uri https://github.com/whichtwix/Data/raw/master/epic/manifests/963137e4c29d4c79a81323b8fab03a40_2025.9.9.manifest -UseBasicParsing -OutFile auman.manifest

.\legendary install 963137e4c29d4c79a81323b8fab03a40 --manifest auman.manifest -y

Write-Host "done"
Write-Host  -BackgroundColor green "Attempting to access the new Among Us folder through file explorer"
Write-Host  -BackgroundColor green "if not found, please find it manually at C:\users\you\games\among us or similar"

Set-Location -Path (Get-Item -Path $env:USERPROFILE)
explorer.exe Games\AmongUs

Write-Host  -BackgroundColor green "making a quick start file in the among us folder, click this to start the game"
Write-Host  -BackgroundColor green "it will be named EpicGamesStarter.exe"
if (!(Test-Path "Games\AmongUs\EpicGamesStarter.exe")) 
{
    Invoke-WebRequest -Uri https://github.com/whichtwix/EpicGamesStarter/releases/download/1.0.2/EpicGamesStarter.exe.zip -UseBasicParsing -OutFile Games\AmongUs\EpicGamesStarter.exe.zip
}
if (Test-Path "Games\AmongUs\EpicGamesStarter.exe.zip") 
{
    Expand-Archive -Path "Games\AmongUs\EpicGamesStarter.exe.zip" -DestinationPath "Games\AmongUs" -Force
    Remove-Item "Games\AmongUs\EpicGamesStarter.exe.zip"
}

Read-Host