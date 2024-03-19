# This scripts downgrades the Epic Games version to 2023.7.12 using the 3rd party client Legendary
# 1. Download Legendary
# 2. Install with the provided manifest
# 3. Create a small launch script for the game

Write-Host -BackgroundColor red "Downloading Legendary, please wait..."

# Download Legendary
curl.exe -LO https://github.com/whichtwix/legendary/releases/latest/download/legendary.exe

# This gives Legendary access to the Epic account, this is needed to download the game
.\legendary auth --import

# we have to do this first so the base url can populate as even putting it as a argument later is not enough
Write-Host  -BackgroundColor red "downloading latest among us version first"
Write-Host  -BackgroundColor red "Please note the 'Install path:' line's folder shown, you will need it later"
.\legendary install 963137e4c29d4c79a81323b8fab03a40

Invoke-WebRequest -Uri https://github.com/whichtwix/Data/raw/master/epic/manifests/963137e4c29d4c79a81323b8fab03a40_2023.11.28.manifest -UseBasicParsing -OutFile auman.manifest


Write-Host  -BackgroundColor red "downloading the downgraded version you need"
Write-Host  -BackgroundColor red "Please note the 'Install path:' line's folder shown, you will need it later"
.\legendary install 963137e4c29d4c79a81323b8fab03a40 --manifest auman.manifest --y

Write-Host  -BackgroundColor red "making a quick start file in this folder, click this to start the game"
'.\legendary launch 963137e4c29d4c79a81323b8fab03a40 --skip-version-check' | Out-File -Encoding ascii -FilePath "2023.11.28.cmd"

Write-Host "done"
Write-Host  -BackgroundColor red "Now you must reinstall the mod to the Install path you noted"
Write-Host  -BackgroundColor red "Attempting to access the new Among Us folder through file explorer"
Write-Host  -BackgroundColor red "if not found, please find it manually"

Set-Location -Path (Get-Item -Path $env:USERPROFILE)
explorer.exe Games\AmongUs

Read-Host