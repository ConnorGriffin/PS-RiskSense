[cmdletBinding()]
param(
    [String]$Phase,
    [Switch]$WhatIf
)

Switch ($Phase) {
    'Install' {
        # https://github.com/rubrikinc/PowerShell-Module/blob/master/tests/install.ps1
        [string[]]$PowerShellModules = @("Pester", "posh-git", "platyPS", "InvokeBuild")
        [string[]]$PackageProviders = @('NuGet', 'PowerShellGet')
        #[string[]]$ChocolateyPackages = @('nodejs', 'calibre')
        #[string[]]$NodeModules = @('gitbook-cli', 'gitbook-summary')

        # Line break for readability in AppVeyor console
        Write-Host -Object ''

        # Install package providers for PowerShell Modules
        ForEach ($Provider in $PackageProviders) {
            If (!(Get-PackageProvider $Provider -ErrorAction SilentlyContinue)) {
                $null = Install-PackageProvider $Provider -Force -ForceBootstrap -Scope CurrentUser
            }
        }

        # Install the PowerShell Modules
        ForEach ($Module in $PowerShellModules) {
            If (!(Get-Module -ListAvailable $Module -ErrorAction SilentlyContinue)) {
                Install-Module $Module -Scope CurrentUser -Force -Repository PSGallery
            }
            Import-Module $Module
        }

        # Install Chocolatey
        #Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

        # Install Chocolatey packages
        #ForEach ($Package in $ChocolateyPackages) {choco install $Package -y --no-progress}

        # Install Node packages
        #ForEach ($Module in $NodeModules) {npm install -g $Module}
    }
    'Test' {
        # Update the build version to match the module version, append the commit ID
        $commit = $env:APPVEYOR_REPO_COMMIT.Substring(0,8)
        $moduleInfo = Import-PowerShellDataFile -Path .\PS-RiskSense\PS-RiskSense.psd1
        Update-AppveyorBuild -Version "$($moduleInfo.ModuleVersion)-$commit"

        # Run the pester tests
        $res = Invoke-Pester -Path ".\Tests" -OutputFormat NUnitXml -OutputFile TestsResults.xml -PassThru
        (New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path .\TestsResults.xml))
        if ($res.FailedCount -gt 0) {
            throw "$($res.FailedCount) tests failed."
        }
    }
    'Deploy' {
        # Deploy the module
        try {
            Publish-Module -Path .\PS-RiskSense\ -NugetApiKey $ENV:PSGalleryAPIKey -WhatIf:$WhatIf
        }
        catch {
            throw $error[0]
        }
    }
}
