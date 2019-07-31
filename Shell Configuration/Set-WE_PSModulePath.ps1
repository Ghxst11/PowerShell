﻿<#
.Resources
    https://docs.microsoft.com/en-us/powershell/developer/module/modifying-the-psmodulepath-installation-path
.Description
    To add a temporary value that is available only for the current session, run the following command at the command line:
    To add a persistent value that is available whenever a session is opened, add the following command to a Windows PowerShell profile:
    To add a persistent environment variable
    To remove a path, include a second \ in the path, e.g. C:\\temp
#>

Function Set-WE_PSModulePath {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('Path')]
        [String]
        $ModulePath,

        [Parameter(Mandatory = $True)]
        [validateset('Temporary', 'Profile-AllUsersAllHosts', 'Profile-AllUsersCurrentHost', 'Profile-CurrentUserCurrentHost', 'Profile-CurrentUsersAllHosts')]
        [String]
        $Scope

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Try {

            Switch ($Scope) {

                'Temporary' { $env:PSModulePath = $env:PSModulePath + ";$ModulePath" }
                'Profile-AllUsersAllHosts' { Add-Content -Path $Profile.AllUsersAllHosts -Value "$env:PSModulePath = $env:PSModulePath + ';$ModulePath'" }
                'Profile-AllUsersCurrentHost' { Add-Content -Path $Profile.AllUsersCurrentHost -Value "$env:PSModulePath = $env:PSModulePath + ';$ModulePath'" }
                'Profile-CurrentUsersAllHosts' { Add-Content -Path $Profile.CurrentUserAllHosts -Value "$env:PSModulePath = $env:PSModulePath + ';$ModulePath'" }
                'Profile-CurrentUserCurrentHost' { Add-Content -Path $Profile.CurrentUserCurrentHost -Value "$env:PSModulePath = $env:PSModulePath + ';$ModulePath'" }
                'EnvironmentVariable' {
                    $CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath")
                    [Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + ";$ModulePath")
                }
                'Remove' { $env:PSModulePath = $env:PSModulePath -replace ";$ModulePath" }

            }

            $Property = [Ordered] @{
                Status = 'Successful'
                Scope  = $Scope
            }

            $PSModulePath = $env:PSModulePath.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)

            For ($i = 0; $i -lt $PSModulePath.Length; $i++) {

                $Property += @{
                    "PSModulePath[$i]" = $PSModulePath[$i]
                }

            }

        }

        Catch {

            Write-Verbose "Unable to set the PSModule path under scope $Scope. Verify you have permissions to write to the specified scope."
            $Property = [Ordered] @{
                Status = 'Unsuccessful'
                Scope  = $Scope
            }

        }

        Finally {

            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}