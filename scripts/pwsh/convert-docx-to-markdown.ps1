# Find all docx files in HOME/workspace/sergeant
# For each file in the list, convert it to markdown using pandoc
# Save the markdown file in the same directory as the docx file
# Path: sdk\scripts\convert-docx-to-markdown.ps1

function Convert-AllDocxToMd {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    Get-DocxFiles -Path $Path | %{
        $DocxPath = $_.FullName
        $DocxDir = Split-Path -Path $DocxPath -Parent
        $DocxName = Split-Path -Path $DocxPath -Leaf
        $DocxNameNoExt = $DocxName -replace '\.docx$'
        $MdPath = Join-Path -Path $DocxDir -ChildPath "$($DocxNameNoExt).md"
        if (!(Test-Path -Path $MdPath)) {
            Write-Host "Convert Docx to Md: $MdPath"
            Set-Location $DocxDir
            pandoc.exe --extract-media=./ $DocxName -o $MdPath -t gfm
        }
        Copy-Attachments -DocxPath $DocxPath -MdPath $MdPath
    }
}

Get-ChildItem -Path $HOME\workspace\sergeant -Recurse -Filter *.docx | %{
    $DocxPath = $_.FullName
    $DocxDir = Split-Path -Path $DocxPath -Parent
    $DocxName = Split-Path -Path $DocxPath -Leaf
    $DocxNameNoExt = $DocxName -replace '\.docx$'
    $MdPath = Join-Path -Path $DocxDir -ChildPath "$($DocxNameNoExt).md"
    if (!(Test-Path -Path $MdPath)) {
        Write-Host "Convert Docx to Md: $MdPath"
        Set-Location $DocxDir
        pandoc.exe --extract-media=./ $DocxName -o $MdPath -t gfm
    }
}

function Get-DocxFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    Get-ChildItem -Path $Path -Filter *.docx
}

function Copy-Attachments {
    param(
        [Parameter(Mandatory=$true)]
        [string]$DocxPath,
        [Parameter(Mandatory=$true)]
        [string]$MdPath
    )
    $DocxDir = Split-Path -Path $DocxPath -Parent
    $DocxName = Split-Path -Path $DocxPath -Leaf
    $DocxNameNoExt = $DocxName -replace '\.docx$'
    $MdDir = Split-Path -Path $MdPath -Parent
    $MdName = Split-Path -Path $MdPath -Leaf
    $MdNameNoExt = $MdName -replace '\.md$'
    $AttachmentsDir = Join-Path -Path $DocxDir -ChildPath "$($DocxNameNoExt)_files"
    if (Test-Path -Path $AttachmentsDir) {
        $Attachments = Get-ChildItem -Path $AttachmentsDir -Recurse
        foreach ($Attachment in $Attachments) {
            $AttachmentPath = $Attachment.FullName
            $AttachmentDir = Split-Path -Path $AttachmentPath -Parent
            $AttachmentName = Split-Path -Path $AttachmentPath -Leaf
            $AttachmentNameNoExt = $AttachmentName -replace '\.[^.]+$'
            $AttachmentExt = $AttachmentName -replace '^[^.]+\.'
            $AttachmentNewName = "$($MdNameNoExt)_$($AttachmentNameNoExt).$($AttachmentExt)"
            $AttachmentNewPath = Join-Path -Path $MdDir -ChildPath $AttachmentNewName
            if (!(Test-Path -Path $AttachmentNewPath)) {
                Write-Host "Copy Attachment: $AttachmentNewPath"
                Copy-Item -Path $AttachmentPath -Destination $AttachmentNewPath
            }
        }
    }
}



