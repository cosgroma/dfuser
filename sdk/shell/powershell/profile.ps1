# Powershell Profile for CurrentUserAllHosts
$DEBUG = $false

if ($DEBUG -eq $true) {
    Write-Host "PowerShell Profile for CurrentUserAllHosts"
}

# Check the current execution policy and set it to RemoteSigned if it is not already set to RemoteSigned
if ((Get-ExecutionPolicy) -ne "RemoteSigned") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -Confirm:$false -WhatIf -Verbose
    Write-Host "Execution Policy set to RemoteSigned"
}

# Check for PowerShellGet module and install if not installed
if (!(Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Scope CurrentUser -Force -Confirm:$false -WhatIf -Verbose
    Write-Host "PowerShellGet module installed"
}

# Check for PackageManagement module and install if not installed
if (!(Get-Module -ListAvailable -Name PackageManagement)) {
    Install-Module -Name PackageManagement -Scope CurrentUser -Force -Confirm:$false -WhatIf -Verbose
    Write-Host "PackageManagement module installed"
}

# Function to check the current execution policy and set it to RemoteSigned if it is not already set to RemoteSigned
function Set-ExecutionPolicy-RemoteSigned {
    if ((Get-ExecutionPolicy) -ne "RemoteSigned") {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -Confirm:$false -WhatIf -Verbose
        Write-Host "Execution Policy set to RemoteSigned"
    }
}

# Get profile directory
$profile_dir = Split-Path -Parent $profile

# source all scripts in the Scripts subdirectory of the profile directory, Write-Host the name of the script being sourced
Get-ChildItem -Path "$profile_dir\Scripts" -Filter *.ps1 | ForEach-Object {
    if ($DEBUG -eq $true) {
        Write-Host "Sourcing $($_.Name)"
    }
    . $_.FullName
}

$DEV_MODULES = @(
    "Pester"
    "Posh-Git"
    "PSReadLine"
)

# Check for development modules and install
foreach ($module in $DEV_MODULES) {
    if (!(Get-Module -ListAvailable -Name $module)) {
        Install-Module -Name $module -Scope CurrentUser -Force -Confirm:$false -WhatIf -Verbose
        if ($DEBUG -eq $true) {
            Write-Host "$module module installed"
        }
    }
}

# load apikeys as environment variables based on filenames of pattern ('name'.apikey) in $HOMEDIR/.dfuser/apikeys
# have the environment variable name based on the pattern 'NAME'_API_KEY
$apikeys = Get-ChildItem -Path "$($env:HOMEDRIVE)$($env:HOMEPATH)\.dfuser\apikeys" -Filter *.apikey

# If API not in environment variables, load it from file
foreach ($apikey in $apikeys) {
    # Write-Host "Loading $($apikey.BaseName.ToUpper())_API_KEY environment variable"
    $environment_variable_name = $apikey.BaseName.ToUpper() + "_API_KEY"
    $environment_variable_value = Get-Content -Path $apikey.FullName
    
    if (!(Test-Path -Path "env:$environment_variable_name")) {
        Write-Host "Environment Variable $environment_variable_name not found"
        # $env:$environment_variable_name = $environment_variable_value
        [Environment]::SetEnvironmentVariable($environment_variable_name, $environment_variable_value, [EnvironmentVariableTarget]::User)
    }
    else {
        if ($DEBUG -eq $true) {
            Write-Host "$environment_variable_name found"
        }
        # Write-Host "Environment Variable $environment_variable_name = " [Environment]::GetEnvironmentVariable($environment_variable_name, [EnvironmentVariableTarget]::User)
    }
}

# function to show the value of environment variables that have the pattern 'NAME'_API_KEY
function Show-ApiKeys {
    $apikeys = Get-ChildItem -Path "$($env:HOMEDRIVE)$($env:HOMEPATH)\.dfuser\apikeys" -Filter *.apikey
    # foreach ($apikey in $apikeys) {
    #     Write-Host "$($apikey.BaseName.ToUpper())_API_KEY = $($env:($apikey.BaseName.ToUpper() + "_API_KEY"))"
    # }
}

# function to find the environment variables that have the pattern 'NAME'_API_KEY
function Find-ApiKeys {
    $env | Where-Object { $_.Key -match "_API_KEY" }
}

function Show-ProfileHelp {
    Write-Host "Profile Help"
    Write-Host "-----------"
    Write-Host "Set-ExecutionPolicy-RemoteSigned - Check the current execution policy and set it to RemoteSigned if it is not already set to RemoteSigned"
    Write-Host "Show-ApiKeys - Show the value of environment variables that have the pattern 'NAME'_API_KEY"
    Write-Host "Find-ApiKeys - Find the environment variables that have the pattern 'NAME'_API_KEY"
}

# NVM for Windows
# $env:NVM_HOME = "$($env:HOMEDRIVE)$($env:HOMEPATH)\.nvm"
$env:NVM_HOME = "$env:HOMEPATH\AppData\Roaming\nvm"
# Add NVM to PATH if NVM_DIR in environment variables
if (Test-Path -Path "$env:NVM_HOME") {
    $env:PATH = "$($env:NVM_HOME);$($env:PATH)"
}

Write-Host "Show-ProfileHelp function for help"