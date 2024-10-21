# Change the URL and file name if there's a new version of Android Studio available
$url = "https://redirector.gvt1.com/edgedl/android/studio/install/2022.2.1.19/android-studio-2022.2.1.19-windows.exe"
$output = "android-studio-installer.exe"

# Download Android Studio installer
Write-Host "Downloading Android Studio..."
Invoke-WebRequest -Uri $url -OutFile $output

# Run the installer
Write-Host "Starting Android Studio installation..."
Start-Process -FilePath $output -Wait

# Remove the installer after installation
Write-Host "Removing Android Studio installer..."
Remove-Item $output

Write-Host "Android Studio installation complete!"
