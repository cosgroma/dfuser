
# Set ACLPath from the command line
$ACLPath = $args[0]
# $ACLPath = 
$Identity = "Users"
$FileSystemRight = "FullControl" 
$Propagation = "1"
$inheritance = "3"
$RuleType = "Allow"

Try {
    $ACL = Get-Acl -Path $ACLPath
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($Identity,$FileSystemRight,$inheritance,$Propagation,$RuleType)
    $ACL.SetAccessRule($AccessRule)
    $ACL | Set-Acl -Path $ACLPath
}
Catch {
    $ErrorMsg = $_.Exception.Message
    Write-Host "Set folder permissions error: $ErrorMsg"
    Exit 421
}