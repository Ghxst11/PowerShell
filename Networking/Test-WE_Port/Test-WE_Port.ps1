﻿<#
.Description
    PortQryV2.exe included with this package.
    https://support.microsoft.com/en-za/help/310099/description-of-the-portqry-exe-command-line-utility
    Allows for testing of UDP and TCP ports, particularly useful for DNS name queries.
    Well-known ports range from 0 through 1023.
    Registered ports are 1024 to 49151
    Can test on multiple ports
.To Do
#>

Param(
    [String[]] $HostName,
    [ValidateSet('TCP', 'UDP', 'Both')]
    [String] $Protocol,
    [ValidateRange(0, 65535)]
    [Int] $Port,
    [ValidateSet('SMTP', 'HTTP', 'HTTPS', 'FTP', 'Telnet', 'IMAP', 'RDP', 'SSH', 'DNS', 'DHCP', 'POP3', 'PortRange', 'SourcePort')]
    [String] $CommonPort

)

Begin { }

Process {

    Foreach ($Hst in $HostName) {

        Try {
    
            Switch ($CommonPort) {
                SMTP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 25 }
                HTTP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 80 }
                HTTPS { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 443 }
                FTP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 21, 22 }
                Telnet { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 23 }
                IMAP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 143 }
                RDP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 3389 }
                SSH { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'TCP' -o 22 }
                DNS { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'Both' -o 53 }
                DHCP { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'UDP' -o 67, 68 }
                POP3 { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'UDP' -o 110 }
                PortRange { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'UDP' -r $Port }
                SourcePort { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p 'UDP' -o $Port }
                Default { $PortQry = & "$PSScriptRoot\PortQryV2\PortQry.exe" -n $Hst -p $Protocol -o $Port }
            }

            $DNSResolve = $PortQry | Select-String -Pattern 'Resolved'
            $TestPort = $PortQry | Select-String -Pattern 'Port'
            $Property = @{
                HostName   = $Hst
                DNSResolve = $DNSResolve
                TestPort   = $TestPort
            }
        }

        Catch {
            $Property = @{
                HostName   = $Hst
                DNSResolve = 'Null'
                TestPort   = 'Null'
            }
        }

        Finally {
            $Object = New-Object -TypeName PSObject -Property $Property
            Write-Output $Object
        }

    }

}

End { }