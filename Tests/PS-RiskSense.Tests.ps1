Import-Module .\PS-RiskSense\PS-RiskSense.psd1 -Force

# Disable default parameter values during testing
$defaultParam = $PSDefaultParameterValues["Disabled"]
$PSDefaultParameterValues["Disabled"] = $true

Describe 'Public functions exports' {
    $files = Get-ChildItem -Path .\PS-RiskSense\Public\*.ps1
    $exportedFunctions = (Get-Module -Name PS-RiskSense).ExportedFunctions.Values.Name
    
    Context 'File names match the function they export' {
        $files.ForEach{
            It "$($_.Name) exports $($_.BaseName)" {
                $content = Get-Content $_.FullName 
                $function = $content[0].Split(' ')[1]
                $function | Should -Be $_.BaseName
            }
        }
    }

    Context 'All public files correspond to an exported function' {
        $files.ForEach{
            It "$($_.BaseName) is in exported functions" {
                $_.BaseName | Should -BeIn $exportedFunctions
            }
        }
    }

    Context 'All exported functions correspond to a public file' {
        $exportedFunctions.ForEach{
            It "$_.ps1 is in Public" {
                ".\PS-RiskSense\Public\$_.ps1" | Should -Exist
            }
        }
    }
}

# Restore the original default parameter values state after testing
$PSDefaultParameterValues["Disabled"] = $defaultParam