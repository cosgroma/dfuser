# This is a PowerShell script that will make your PowerShell experience more like Bash
# 
# This script is based on the following article:
# https://devblogs.microsoft.com/powershell/powershell-7-0-preview-3/
#
# List of useful bash commands to have in PowerShell:
# https://www.howtogeek.com/672419/10-useful-bash-commands-that-are-missing-from-windows-powershell/

# If .profile.ps1 as set DEBUG = false then we are going to be quiet
if ($DEBUG -eq $true) {
    # Write to host that we are running this script
    Write-Host "Running BeLikeBash.ps1"
}

# 1. which
# 2. ls
# 3. cd
# 4. alias
# 5. grep
# 6. cat
# 7. curl
# 8. wget
# 9. find
# 10. awk
# 11. sed
# 12. sort
# 13. uniq
# 14. ps
# 15. kill
# 16. killall
# 17. top
# 18. df
# 19. du
# 20. free
# 21. netstat
# 22. ifconfig
# 23. ping
# 24. traceroute
# 25. dig
# 26. whois
# 27. ssh
# 28. scp
# 29. touch
$bash_functions = 'which', 'ls', 'cd', 'alias', 'grep', 'cat', 'curl', 'wget', 'find', 'awk', 'sed', 'sort', 'uniq', 'ps', 'kill', 'killall', 'top', 'df', 'du', 'free', 'netstat', 'ifconfig', 'ping', 'traceroute', 'dig', 'whois', 'ssh', 'scp', 'touch'


# which function
function which($arg) {
    Get-Command $arg | Select-Object -ExpandProperty Path        
}

# alias
function alias($arg) {
    Set-Alias $arg
}

# grep
function grep($arg) {
    Select-String $arg
}
# Check if we have cat alias, if not, use this function
if (!(Get-Alias cat)) {
    Set-Alias cat Get-Content
}

# curl
# wget

function wget($arg) {
    Invoke-WebRequest $arg
}

# find
# awk
# sed
function sed($arg) {
    $arg | Select-String $arg
}
# uniq

function uniq($arg) {
    $arg | Get-Unique
}

function ifconfig($arg) {
    Get-NetIPAddress
}

function touch($arg) {
    New-Item $arg
}

function top($arg) {
    Get-Process
}

function df($arg) {
    Get-PSDrive
}

function du($arg) {
    Get-ChildItem $arg | Measure-Object -Property Length -Sum
}

function free($arg) {
    Get-Process
}

function traceroute($arg) {
    Test-NetConnection $arg
}

# function to check if we have all the bash functions we want in PowerShell and notify the user if we don't
function CheckForBashFunctions() {
    # Loop through the list of bash functions we want in PowerShell
    foreach ($bash_function in $bash_functions) {
        # Check if we have the bash function in PowerShell
        if (!(Get-Command $bash_function -ErrorAction SilentlyContinue)) {
            # Write to host with emoji that we don't have the bash function in PowerShell
            Write-Host "🤷 -> $bash_function" -ForegroundColor Yellow
        }
        else {
            if ($DEBUG -eq $true) {
                # Write to host with emoji that we have the bash function in PowerShell
                Write-Host "👍 -> $bash_function" -ForegroundColor Green
            }
        }
    }
}

CheckForBashFunctions

if ($DEBUG -eq $true) {
    CheckForBashFunctions
}



