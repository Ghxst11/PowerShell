<#
Requires GroupPolicy Module
To do: (1) Update property array (2) Tidy up Members parameter to accept input for various OU and DC locations.
#>

Function Add-WE_ADGroupMemberComputer {

    [Cmdletbinding(SupportsShouldProcess)]

    Param (

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias('HostName')]
        [String[]] $ComputerName

    )

    Begin {

        $StartErrorActionPreference = $ErrorActionPreference

    }

    Process {

        Foreach ($Computer in $ComputerName) {

            Try {

                $GroupMemberComputer = Add-ADGroupMember -Identity $Identity -Members "CN=$Computer,OU=Computers,OU=Computers,OU=MyBusiness,DC=domain,DC=local"
                $Property = @{
                    Status              = 'Successful'
                    GroupMemberComputer = $GroupMemberComputer
                }

            }

            Catch {

                Write-Verbose "Unable to add $Computer to the desired Active Directory group."
                $Property = @{
                    Status              = 'Unsuccessful'
                    GroupMemberComputer = $GroupMemberComputer
                }

            }

            Finally {

                $Object = New-Object -TypeName PSObject -Property $Property
                Write-Output $Object

            }

        }

    }

    End {

        $ErrorActionPreference = $StartErrorActionPreference

    }

}