# settings
$ExportPath = "C:\Users\$env:USERNAME\OneNoteExport\"
Add-Type -AssemblyName "Microsoft.Office.Interop.OneNote"

# Create OneNote application
$OneNote = New-Object -ComObject OneNote.Application

# Set note hierarchy
[xml]$Hierarchy = ""
$OneNote.GetHierarchy("", [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsPages, [ref]$Hierarchy)

# Get info foreach notebook
$Hierarchy.Notebooks.Notebook | ?{$_.name -eq 'TODO'} | %{
    $Notebook = $_
    $Name = $Notebook.name
    $NotebookPath = Join-Path -Path $ExportPath -ChildPath $Name

    Write-Host "Export Notebook: $Name"
    New-Item -Force -Path $NotebookPath -ItemType directory | Out-Null

    $NotebookOnepkgPath = Join-Path -Path $ExportPath -ChildPath "$($Name).onepkg"
    if (!(Test-Path -Path $NotebookOnepkgPath)) {
        Write-Host "Export Notebook as Onepkg: $NotebookOnepkgPath"
        $OneNote.Publish($Notebook.ID, $NotebookOnepkgPath, 1, "")
    }

    # Get info about each section
    $Notebook.ChildNodes| ?{$_.isRecycleBin -ne 'true'} | %{
        $Section = $_
        $SectionIndex = [array]::indexof($Notebook.ChildNodes, $_)
        $SectionName = "$($SectionIndex)_$($Section.name)"
        $SectionPath = Join-Path -Path $NotebookPath -ChildPath $SectionName

        Write-Host "Processing Section: $SectionName"
        New-Item -Force -Path $SectionPath -ItemType directory | Out-Null

        # Process pages
        $Section.ChildNodes | %{
            $Page = $_
            $PageIndex = [array]::indexof($Section.ChildNodes, $_)
            $PageName = "$($PageIndex)_$($Page.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
            $PagePath = Join-Path -Path $SectionPath -ChildPath $PageName

            Write-Host "Processing Page: $PageName"
            New-Item -Force -Path $PagePath -ItemType directory | Out-Null

            $PageHtmPath = Join-Path -Path $PagePath -ChildPath 'index.htm'
            if (!(Test-Path -Path $PageHtmPath)) {
                Write-Host "Export Page as Htm: $PageHtmPath"
                $OneNote.Publish($Page.ID, $PageHtmPath, 7, "")
            }

            $PageDocxPath = Join-Path -Path $PagePath -ChildPath 'index.docx'
            if (!(Test-Path -Path $PageDocxPath)) {
                Write-Host "Export Page as Docx: $PageDocxPath"
                $OneNote.Publish($Page.ID, $PageDocxPath, 5, "")
            }

            $PageMdPath = Join-Path -Path $PagePath -ChildPath 'index.md'
            if (!(Test-Path -Path $PageMdPath)) {
                Write-Host "Convert Docx to Md: $PageMdPath"
                Set-Location $PagePath
                pandoc.exe --extract-media=./ .\index.docx -o index.md -t gfm
            }

            # Export Attachments
            $xml = ''
            $schema = @{one=”http://schemas.microsoft.com/office/onenote/2013/onenote”}
            $onenote.GetPageContent($Page.ID, [ref]$xml)
            $xml | Select-Xml -XPath "//one:Page/one:Outline/one:OEChildren/one:OE/one:InsertedFile" -Namespace $schema | %{
                $AttachmentPath = Join-Path -Path $PagePath -ChildPath $_.Node.preferredName
                Write-Host "Export Attachment: $($AttachmentPath)"
                Copy-Item -Force $_.Node.pathCache -Destination $AttachmentPath
            }
        }
    }
}