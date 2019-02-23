$path = "$PSScriptRoot/../@Overthrow"
$pathAddons = "$path/addons"
If(!(Test-Path $pathAddons))
{
    New-Item -ItemType -type Directory -Force -Path $pathAddons
}

Copy-Item "../logo_overthrow.paa" $path -Force
Copy-Item "../mod.cpp" $path -Force

$biPath = switch((Get-WmiObject Win32_OperatingSystem).OSArchitecture)
{
    "64-bit" { Get-ChildItem "HKLM:\SOFTWARE\WOW6432Node\Bohemia Interactive\" | ForEach-Object { Get-ItemProperty $_.pspath } }
    "32-bit" { Get-ChildItem "HKLM:\SOFTWARE\Bohemia Interactive Studio\" | ForEach-Object { Get-ItemProperty $_.pspath } }
    default { @( ) }
}
$abpath = $biPath.path | ForEach-Object { if ($_ -match "AddonBuilder") { return $_ } }
if (!(Test-Path (Join-Path $abpath "\AddonBuilder.exe") -ErrorAction SilentlyContinue))
{ 
    Write-Host "Unable to find AddonBuilder. Make sure its installed"
}
else
{
    $abpath = Join-Path $abpath "\AddonBuilder.exe";

    $includes = "$PSScriptRoot/includes.txt"
    if (!(Test-Path $includes))
    {
        "*.xml;*.pac;*.paa;*.sqf;*.sqs;*.bikb;*.fsm;*.wss;*.ogg;*.wav;*.fxy;*.csv;*.html;*.lip;*.txt;*.wrp;*.bisurf;*.rvmat;*.sqm;*.ext;*.hpp" | Out-File $includes -Encoding "UTF8"
    }

    & $abpath "$PSScriptRoot/../addons/overthrow_main" "$pathAddons" "-prefix=ot" "-include=$PSScriptRoot/includes.txt"
}