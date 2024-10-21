# Provides functions for working with OneNote Notebooks.
# These functions are, given input a Notebook name, a Section name, and a Page name, return the corresponding OneNote object.

# C:\WINDOWS\assembly\GAC_MSIL\Microsoft.Office.Interop.OneNote\15.0.0.0__71e9bce111e9429c\
# $OFFICE_VERSION = "15.0.0.0__71e9bce111e9429c"
# Add-Type -Path $env:WINDIR\assembly\GAC_MSIL\office\$OFFICE_VERSION\office.dll
# # Add-Type -Path $env:WINDIR\assembly\GAC_MSIL\Microsoft.Office.Interop.Outlook\$OFFICE_VERSION\Microsoft.Office.Interop.Outlook.dll
# Add-Type -Path $env:WINDIR\assembly\GAC_MSIL\Microsoft.Office.Interop.OneNote\$OFFICE_VERSION\Microsoft.Office.Interop.OneNote.dll
# Add-Type -AssemblyName 'Microsoft.Office.Interop.OneNote' -Passthru
# Microsoft.Office.Interop.
# "Access"
# "Access.Dao"
# "Excel"
# "Graph"
# "MSProject"
# "OneNote"
# "Outlook"
# "OutlookViewCtl"
# "PowerPoint"
# "SmartTag"
# "Word"
# Create Interop List
# $InteropList = [AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.FullName -like "Microsoft.Office.Interop.*" } | ForEach-Object { $_.FullName } | ForEach-Object { $_.Replace("Microsoft.Office.Interop.", "") }


function Get-OneNoteHierarchy {
    param(
    )
    # Create OneNote application
    $OneNote = New-Object -ComObject OneNote.Application
    [xml]$Hierarchy = ""
    $OneNote.GetHierarchy("", [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsPages, [ref]$Hierarchy)
    return $Hierarchy
}


# Get all the Notebook Names Known
function Get-OneNoteNotebookNames {
    $Hierarchy = Get-OneNoteHierarchy
    $Notebooks = $Hierarchy.Notebooks.Notebook
    $NotebookNames = $Notebooks.name
    return $NotebookNames
}

function Show-NotebookNames {
    $NotebookNames = Get-OneNoteNotebookNames
    Write-Host "Notebooks:"
    $NotebookNames | ForEach-Object {Write-Host "  $_"}
}

function Get-OneNoteNotebook {
    param(
        [string]$NotebookName
    )

    $Hierarchy = Get-OneNoteHierarchy
    $Notebook = $Hierarchy.Notebooks.Notebook | ?{$_.name -eq $NotebookName}
    return $Notebook
}


function Show-SectionNames {
    param(
        [string]$NotebookName
    )

    $Sections = Get-AllOneNoteSections -NotebookName $NotebookName
    $SectionNames = $Sections.name
    Write-Host "Sections:"
    $SectionNames | ForEach-Object {Write-Host "  $_"}
}

function Get-OneNoteSection {
    param(
        [string]$NotebookName,
        [string]$SectionName
    )

    $Notebook = Get-OneNoteNotebook -NotebookName $NotebookName
    $Section = $Notebook.ChildNodes | ?{$_.name -eq $SectionName}
    return $Section
}

function Get-AllOneNoteSections {
    param(
        [string]$NotebookName
    )

    $Notebook = Get-OneNoteNotebook -NotebookName $NotebookName
    $Sections = $Notebook.ChildNodes | ?{$_.isRecycleBin -ne 'true'}
    return $Sections
}



function Get-AllOneNoteNotebookNodes {
    param(
        [string]$NotebookName
    )

    $Notebook = Get-OneNoteNotebook -NotebookName $NotebookName
    $Nodes = $Notebook.ChildNodes.ChildNodes
    return $Nodes
}

function Show-NodeNames {
    param(
        [string]$NotebookName
    )

    $Nodes = Get-AllOneNoteSections -NotebookName $NotebookName

    $AllNodes = $Nodes | ForEach-Object {Get-NodesRecursive}
    $NodeNames = $AllNodes.name
    Write-Host "Nodes:"
    $NodeNames | ForEach-Object {Write-Host "  $_"}
}

function Get-AllOneNoteSecionPages {
    param(
        [string]$NotebookName,
        [string]$SectionName
    )

    $Section = Get-OneNoteSection -NotebookName $NotebookName -SectionName $SectionName
    $Pages = $Section.ChildNodes
    return $Pages
}

function Get-NodesRecursive {
    param(
        [object]$Node
    )
    # Given a node if it has children, for each child, call this function recursively
    # and return the result. Otherwise, return the node.
    if ($Node.ChildNodes) {
        $Nodes = $Node.ChildNodes | ?{$_.isRecycleBin -ne 'true'}
        $Nodes += $Nodes.ChildNodes | ?{$_.isRecycleBin -ne 'true'}
        return $Nodes
    } else {
        return $Node
    }
}

# function to show notebook heirarchy
function Show-NotebookHeirarchy {
    param(
        [string]$NotebookName
    )
    $Hierarchy = Get-OneNoteHierarchy
    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        Write-Host "# $NotebookName"
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | % {
            $Section = $_
            # Get Section Index
            $SectionName = $Section.name
            $SectionIndex = $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | ? { $_.name -eq $SectionName } | Select-Object -First 1
            Write-Host "## $SectionIndex $SectionName"
            $Section.ChildNodes | % {
                $Page = $_
                $PageName = $Page.name
                $PageIndex = $Section.ChildNodes | ? { $_.name -eq $PageName } | Select-Object -First 1
                Write-Host "### $PageName"
                $Page.ChildNodes | % {
                    $Subpage = $_
                    $SubpageName = $Subpage.name
                    $SubpageIndex = $Page.ChildNodes | ? { $_.name -eq $SubpageName } | Select-Object -First 1
                    Write-Host "### $SubpageName"
                    $SubPage.ChildNodes | % {
                        $SubSubpage = $_
                        $SubSubpageName = $SubSubpage.name
                        $SubSubpageIndex = $SubPage.ChildNodes | ? { $_.name -eq $SubSubpageName } | Select-Object -First 1
                        Write-Host "#### $SubSubpageName"
                        # Write Content of SubSubpage
                        # Write-Host $SubSubpage.Content 
                    }
                    # Write-Host $Subpage.Content 
                    # Write-Host "$($Notebook.name)->$($Section.name)->$($Page.name)->$($Subpage.name)"
                }
                # Write-Host $Page.Content 
            }
        }
    }
}
# | Out-File -FilePath "$($Notebook.name)-$($Section.name)-$($Page.name)-$($Subpage.name)-$($SubSubpage.name).html" -Encoding UTF8
function Get-SlugifiedString {
    param(
        [string]$String
    )
    $SlugifiedString = $String -replace '[^\w\-]', '-' -replace '\-+', '-' -replace '^\-|\-$', ''
    return $SlugifiedString
}

# function to show notebook heirarchy
function Export-NotebookContent {
    param(
        [string]$NotebookName,
        [string]$SectionName,
        [string]$PageName,
        [string]$SubpageName,
        [string]$OutputPath
    )

    
    # If $PageName is Empty, export all pages in the section
    # If $SectionName is Empty, export all sections in the notebook

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        # Create Notebook Directory at Output Path
        $NotebookPath = Join-Path -Path $OutputPath -ChildPath $Notebook.name
        # Slugify Notebook Name
        $NotebookPath = Get-SlugifiedString -String $NotebookPath
        New-Item -Force -Path $NotebookPath -ItemType directory | Out-Null
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | ? { $_.name -eq $SectionName } | % {
            $Section = $_
            # Create Section Directory at Output Path
            $SectionPath = Join-Path -Path $OutputPath -ChildPath $Section.name
            # Slugify Section Name
            $SectionPath = Get-SlugifiedString -String $SectionPath
            New-Item -Force -Path $SectionPath -ItemType directory | Out-Null
            $Section.ChildNodes | ? { $_.name -eq $PageName } | % {
                $Page = $_
                $PageIndex = [array]::indexof($Page.ParentNode.ChildNodes, $Page)
                $PageName = "$($PageIndex)_$($Page.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
                Write-Host "Processing Page: $PageName"

                $PagePath = Join-Path -Path $ExportPath -ChildPath $PageName
                New-Item -Force -Path $PagePath -ItemType directory | Out-Null
                
                Export-Page -Page $Page -ExportPath $PagePath
                $Page.ChildNodes | ? { $_.name -eq $SubpageName } | % {
                    $Subpage = $_
                    $SubpageIndex = [array]::indexof($Subpage.ParentNode.ChildNodes, $Subpage)
                    $SubpageName = "$($SubpageIndex)_$($Subpage.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
                    Write-Host "Processing Subpage: $SubpageName"

                    $SubpagePath = Join-Path -Path $PagePath -ChildPath $SubpageName
                    New-Item -Force -Path $SubpagePath -ItemType directory | Out-Null
                    
                    Export-Page -Page $Subpage -ExportPath $SubpagePath
                    
                }
            }
        }
    }
}

function Export-Page {
    param(
        [object]$Page,
        [string]$ExportPath
    )

    # If $ExportPath Does Not Exist, Create It
    if (!(Test-Path -Path $ExportPath)) {
        New-Item -Force -Path $ExportPath -ItemType directory | Out-Null
    }

    $PageDocxPath = Join-Path -Path $ExportPath -ChildPath 'index.docx'
    if (!(Test-Path -Path $PageDocxPath)) {
        Write-Host "Export Page as Docx: $PageDocxPath"
        $OneNote.Publish($Page.ID, $PageDocxPath, 5, "")
    }

    $PageMdPath = Join-Path -Path $ExportPath -ChildPath 'index.md'
    if (!(Test-Path -Path $PageMdPath)) {
        Write-Host "Convert Docx to Md: $PageMdPath"
        Set-Location $ExportPath
        pandoc.exe --extract-media=./ .\index.docx -o index.md -t gfm
    }

    $PageHtmPath = Join-Path -Path $ExportPath -ChildPath 'index.htm'
    if (!(Test-Path -Path $PageHtmPath)) {
        Write-Host "Export Page as Htm: $PageHtmPath"
        $OneNote.Publish($Page.id, $PageHtmPath, [Microsoft.Office.Interop.OneNote.PublishFormat]::Html)
    }
}



function Export-Node {
    param(
        [object]$Node,
        [string]$ExportPath
    )

    # If the node is a page, export it.
    if ($Node.page) {
        $Page = $Node
        $PageIndex = [array]::indexof($Node.ParentNode.ChildNodes, $Node)
        $PageName = "$($PageIndex)_$($Page.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
        $PagePath = Join-Path -Path $ExportPath -ChildPath $PageName

        Write-Host "Processing Page: $PageName"
        New-Item -Force -Path $PagePath -ItemType directory | Out-Null

        # $PageHtmPath = Join-Path -Path $PagePath -ChildPath 'index.htm'
        # if (!(Test-Path -Path $PageHtmPath)) {
        #     Write-Host "Export Page as Htm: $PageHtmPath"
        #     $OneNote.Publish($Page.ID, $PageHtmPath, 7, "")
        # }

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
    } else {
        # If the node is a section, create a directory for it and export its children.
        $Section = $Node
        $SectionIndex = [array]::indexof($Node.ParentNode.ChildNodes, $Node)
        $SectionName = "$($SectionIndex)_$($Section.name)"
        $SectionPath = Join-Path -Path $ExportPath -ChildPath $SectionName

        Write-Host "Processing Section: $SectionName"
        New-Item -Force -Path $SectionPath -ItemType directory | Out-Null

        $Section | Get-NodesRecursive | Export-Node -ExportPath $SectionPath
    }
}

