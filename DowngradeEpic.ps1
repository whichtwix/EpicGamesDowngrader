# This scripts downgrades the Epic Games version to 2023.7.12 using the 3rd party client Legendary
# 1. Download Legendary
# 2. Install with the provided manifest
# 3. Create a small launch script for the game

Write-Host -BackgroundColor red "Downloading Legendary, please wait..."

# Download Legendary
# -UseBasicParsing is needed if the user has not set up IE yet.
Invoke-WebRequest -Uri https://github.com/derrod/legendary/releases/download/0.20.33/legendary.exe -UseBasicParsing -OutFile legendary.exe

# Check if we downloaded a correct legendary release using a SHA256 checksum
$LegendaryHash = Get-FileHash legendary.exe
$CorrectHash = "A64BA3D2A8B71AC8FC396320E7514E3B526E930BC2CC26C05967C3E31C46B130" 
if ( $LegendaryHash.Hash -ne $CorrectHash )
{
	Remove-Item legendary.exe
	Write-Host -BackgroundColor red "Could not validate legendary download"
	Write-Host -BackgroundColor red "Got: $LegendaryHash"
	Write-Host -BackgroundColor red "Please make a screenshot and open a support ticket"
	Read-Host
	exit 1
}

# This gives Legendary access to the Epic account, this is needed to download the game
# Sometimes a login can become invalid so at that point it has to be redone
try
{
	.\legendary auth --import
}
catch
{
	Write-Host -BackgroundColor yellow "could not import a existing login - attempting fresh login"
	try
	{
		.\legendary auth --delete
		.\legendary auth --import
	}
	catch
	{
		Write-Host -BackgroundColor yellow "attempt failed - please login manually"
		.\legendary auth
	}
}

# we have to do this first so the base url can populate as even putting it as a argument later is not enough
Write-Host  -BackgroundColor red "downloading latest among us version first"
Write-Host  -BackgroundColor red "Please note the 'Install path:' line's folder shown, you will need it later"
.\legendary install 963137e4c29d4c79a81323b8fab03a40

Invoke-WebRequest -Uri https://github.com/NuclearPowered/Data/raw/de96ca8940c0a16944eba4fbd9ff1c5f3d701f9a/epic/manifests/963137e4c29d4c79a81323b8fab03a40_Windows_3365.manifest -UseBasicParsing -OutFile auman.manifest


Write-Host  -BackgroundColor red "downloading the downgraded version you need"
Write-Host  -BackgroundColor red "Please note the 'Install path:' line's folder shown, you will need it later"
.\legendary install 963137e4c29d4c79a81323b8fab03a40 --manifest auman.manifest

Write-Host  -BackgroundColor red "making a quick start file in this folder, click this to start the game"
'.\legendary launch 963137e4c29d4c79a81323b8fab03a40 --skip-version-check' | Out-File -Encoding ascii -FilePath "2023.7.12.cmd"

Write-Host "done"
Write-Host  -BackgroundColor red "Now you must reinstall the mod to the Install path you noted"

Read-Host