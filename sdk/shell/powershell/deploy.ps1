# Copy .\profile.ps1 to $profile-dir\profile.ps1
# Copy all scripts in .\Scripts to $profile-dir\Scripts

# Notify of updating profile

# Only update if there are differences
if (!(Compare-Object (Get-Content .\profile.ps1) (Get-Content $profile_dir\profile.ps1))) {
    Write-Host "No differences found in profile.ps1"
} else {
    Write-Host "Updating profile at $profile_dir"
    Copy-Item .\profile.ps1 $profile_dir\profile.ps1
}

# Add line to end of $profile_dir\profile.ps1 for the time we copied the profile
# Add-Content $profile_dir\profile.ps1 "`n# Copied profile at $(Get-Date)"
Write-Host "Copying scripts to $profile_dir\Scripts"
Copy-Item .\Scripts\* $profile_dir\Scripts\
