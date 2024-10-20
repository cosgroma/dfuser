$OneDrivePath = "$env:USERPROFILE\OneDrive"
$GitFolders = Get-ChildItem -Path $OneDrivePath -Recurse -Directory -Filter ".git"

foreach ($GitFolder in $GitFolders) {
    $GitFolderPath = $GitFolder.FullName
    $OneDriveFolderPath = $GitFolderPath.Replace($OneDrivePath, "OneDrive:")
    $OneDriveFolderPath = $OneDriveFolderPath.Replace("\", "/")
    Set-ItemProperty -Path $OneDriveFolderPath -Name "Attributes" -Value ([IO.FileAttributes]::Hidden)
}