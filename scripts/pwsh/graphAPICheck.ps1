# Check for local Graph API access in the current enterprise domain
# This script is intended to be run from a Windows 10 machine that is joined to the enterprise domain
# The script will check for local Graph API access and then check for Graph API access from the current machine

# Check for Windows 10
$windows10 = $true
if ($PSVersionTable.PSVersion.Major -lt 5) {
    $windows10 = $false
    $windows10Message = "Windows 10 is not installed"
}

# Check for Windows 10 Enterprise
$windows10Enterprise = $true

if ($windows10) {
    $windows10Enterprise = (Get-CimInstance -ClassName Win32_OperatingSystem).ProductType -eq 3
    if (-not $windows10Enterprise) {
        $windows10EnterpriseMessage = "Windows 10 Enterprise is not installed"
    }
}

# Check for Windows 10 Enterprise 2015 LTSB
$windows10Enterprise2015LTSB = $true
if ($windows10Enterprise) {
    $windows10Enterprise2015LTSB = (Get-CimInstance -ClassName Win32_OperatingSystem).Version -eq "10.0.10240"
    if (-not $windows10Enterprise2015LTSB) {
        $windows10Enterprise2015LTSBMessage = "Windows 10 Enterprise 2015 LTSB is not installed"
    }
}

 