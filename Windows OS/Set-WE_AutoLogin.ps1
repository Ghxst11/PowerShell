<#
.DESCRIPTION
    Configure Autologon for Windows user account.
#>

[CmdletBinding()]

Param (

    [Parameter(ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $DomainName = '.',

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $UserName,

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True)]
    [ValidateNotNullOrEmpty()]
    [String] 
    $Password

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {
        
        $AutoAdminLogon = Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -Value '1'
        $AutoLogonCount = Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoLogonCount -Value '999'
        $DefaultDomainName = Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultDomainName -Value "$DomainName"
        $DefaultUserName = Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -Value "$UserName" 
        $DefaultPassword = New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -Value "$Password"  -PropertyType String
        $DisableCAD = Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DisableCAD -Value '1' 
        $Property = @{
            AutoAdminLogon    = $AutoAdminLogon
            AutoLogonCount    = $AutoLogonCount
            DefaultDomainName = $DefaultDomainName
            DefaultUserName   = $DefaultUserName
            DefaultPassword   = $DefaultPassword
            DisableCAD        = $DisableCAD
        }

    }

    Catch {

        Write-Warning 'The user accounts were not configured successfully.' -Verbose
        $Property = @{
            AutoAdminLogon    = 'Null'
            AutoLogonCount    = 'Null'
            DefaultDomainName = 'Null'
            DefaultUserName   = 'Null'
            DefaultPassword   = 'Null'
            DisableCAD        = 'Null'
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