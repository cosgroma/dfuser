# Get logged in user home directory via environment variables


# settings
$ExportPath = "C:\Users\$env:USERNAME\workspace\OneNoteExport\"

# Create OneNote application
$OneNote = New-Object -ComObject OneNote.Application

# Set note hierarchy
[xml]$Hierarchy = ""
$OneNote.GetHierarchy("", [Microsoft.Office.InterOp.OneNote.HierarchyScope]::hsPages, [ref]$Hierarchy)

# function to get all notebook names
function Get-NotebookNames {
    $Hierarchy.Notebooks.Notebook | % {
        $_.name
    }
}

# function to get all section names
function Get-SectionNames {
    param(
        [string]$NotebookName
    )

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | % {
            $_.name
        }
    }
}

# function to get all page names
function Get-PageNames {
    param(
        [string]$NotebookName,
        [string]$SectionName
    )

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | ? { $_.name -eq $SectionName } | % {
            $Section = $_
            $Section.ChildNodes | % {
                $_.name
            }
        }
    }
}

# function to get all subpage names
function Get-SubpageNames {
    param(
        [string]$NotebookName,
        [string]$SectionName,
        [string]$PageName
    )

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | ? { $_.name -eq $SectionName } | % {
            $Section = $_
            $Section.ChildNodes | ? { $_.name -eq $PageName } | % {
                $Page = $_
                $Page.ChildNodes | % {
                    $_.name
                }
            }
        }
    }
}

# function to show notebook heirarchy
function Show-NotebookHeirarchy {
    param(
        [string]$NotebookName,
        [string]$SectionName,
        [string]$PageName,
        [string]$SubpageName
    )

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $Notebook = $_
        $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | ? { $_.name -eq $SectionName } | % {
            $Section = $_
            $Section.ChildNodes | ? { $_.name -eq $PageName } | % {
                $Page = $_
                $Page.ChildNodes | ? { $_.name -eq $SubpageName } | % {
                    $Subpage = $_
                    Write-Host "$($Notebook.name)->$($Section.name)->$($Page.name)->$($Subpage.name)"
                }
            }
        }
    }
}

# function to get notebook id
function Get-NotebookId {
    param(
        [string]$NotebookName
    )

    $Hierarchy.Notebooks.Notebook | ? { $_.name -eq $NotebookName } | % {
        $_.ID
    }
}

# For all notebooks show heirarchy
Get-NotebookNames | % {
    $NotebookName = $_
    Get-SectionNames -NotebookName $NotebookName | % {
        $SectionName = $_
        Get-PageNames -NotebookName $NotebookName -SectionName $SectionName | % {
            $PageName = $_
            Get-SubpageNames -NotebookName $NotebookName -SectionName $SectionName -PageName $PageName | % {
                $SubpageName = $_
                Show-NotebookHeirarchy -NotebookName $NotebookName -SectionName $SectionName -PageName $PageName -SubpageName $SubpageName
            }
        }
    }
}

# # Get info for each notebook
# $Hierarchy.Notebooks.Notebook | % {
#     $Notebook = $_
#     $Name = $Notebook.name
#     $NotebookPath = Join-Path -Path $ExportPath -ChildPath $Name

#     Write-Host "Export Notebook: $Name"
#     # New-Item -Force -Path $NotebookPath -ItemType directory | Out-Null

#     # Get info about each section
#     $Notebook.ChildNodes | ? { $_.isRecycleBin -ne 'true' } | % {
#         $Section = $_
#         $SectionIndex = [array]::indexof($Notebook.ChildNodes, $_)
#         $SectionName = "$($SectionIndex)_$($Section.name)"
#         $SectionPath = Join-Path -Path $NotebookPath -ChildPath $SectionName

#         Write-Host "Processing Section: $SectionName"
#         # New-Item -Force -Path $SectionPath -ItemType directory | Out-Null

#         # Process pages
#         $Section.ChildNodes | % {
#             $Page = $_
#             $PageIndex = [array]::indexof($Section.ChildNodes, $_)
#             $PageName = "$($PageIndex)_$($Page.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
#             $PagePath = Join-Path -Path $SectionPath -ChildPath $PageName

#             Write-Host "Processing Page: $PageName"
#             # New-Item -Force -Path $PagePath -ItemType directory | Out-Null

#             # Output hierarchy to file
#             $outputString = "$Name->$SectionName->$PageName"
#             Add-Content -Path $ExportPath\output.txt -Value $outputString
            
#             # Process subpages
#             $Page.ChildNodes | % {
#                 $Subpage = $_
#                 $SubpageIndex = [array]::indexof($Page.ChildNodes, $_)
#                 $SubpageName = "$($SubpageIndex)_$($Subpage.name)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
#                 $SubpagePath = Join-Path -Path $PagePath -ChildPath $SubpageName

#                 Write-Host "Processing Subpage: $SubpageName"
#                 # New-Item -Force -Path $SubpagePath -ItemType directory | Out-Null

#                 # Output hierarchy to file
#                 $outputString = "$Name->$SectionName->$PageName->$SubpageName"
#                 Add-Content -Path $ExportPath\output.txt -Value $outputString
#             }
#         }
#     }
# }
