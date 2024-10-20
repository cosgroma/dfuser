# settings
$ExportPath = "C:\Users\$env:USERNAME\OneDrive\OneNoteExport\"

# Create OneNote application
$OneNote = New-Object -ComObject OneNote.Application

# Set note hierarchy
[xml]$Hierarchy = ""
$OneNote.GetHierarchy("", [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsPages, [ref]$Hierarchy)

# Get info foreach notebook
$Hierarchy.Notebooks.Notebook | %{
    $Notebook = $_
    $Name = $Notebook.name
    $NotebookPath = Join-Path -Path $ExportPath -ChildPath $Name

    Write-Host "Export Notebook: $Name"
    New-Item -Force -Path $NotebookPath -ItemType directory | Out-Null

    $NotebookOnepkgPath = Join-Path -Path $ExportPath -ChildPath "$($Name).onepkg"
    if (!(Test-Path -Path $NotebookOnepkgPath)) {
        Write-Host "Export Notebook as Onepkg: $NotebookOnepkgPath"
        # $OneNote.Publish($Notebook.ID, $NotebookOnepkgPath, 1, "")
    }
}

