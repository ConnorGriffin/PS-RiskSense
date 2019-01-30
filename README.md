# PS-RiskSense
[![Build status](https://ci.appveyor.com/api/projects/status/d9y43a99ko3e7y1r?svg=true)](https://ci.appveyor.com/project/ConnorGriffin/ps-risksense)
[![PSG Version](https://img.shields.io/powershellgallery/v/PS-RiskSense.svg)](https://www.powershellgallery.com/packages/PS-RiskSense)
[![PSG Downloads](https://img.shields.io/powershellgallery/dt/PS-RiskSense.svg)](https://www.powershellgallery.com/packages/PS-RiskSense)

PowerShell Module for RiskSense API.

This module is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/PS-RiskSense).

## Initial setup

### Installing and loading the module
```powershell
# Install the module (if you have PowerShell 5, or the PowerShellGet module).
Install-Module PS-RiskSense -Scope CurrentUser

# Import the module.
Import-Module PS-RiskSense

# Get commands in the module
Get-Command -Module PS-RiskSense

# Get help for a specific command (Get-RiskSenseClient for example)
Get-Help Get-RiskSenseClient -Full
```


