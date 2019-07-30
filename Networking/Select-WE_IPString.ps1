﻿[CmdletBinding()]

Param (

    [Parameter(Mandatory = $True,
        ValueFromPipeline = $True,
        ValueFromPipelineByPropertyName = $True,
        Position = 0)]
    [ValidateNotNullOrEmpty()] 
    [String]
    $String

)

Begin {

    $StartErrorActionPreference = $ErrorActionPreference

}

Process {

    Try {

        $IPString = (Select-String -InputObject $String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value

    }

    Catch { }

    Finally {

        Write-Output $IPString

    }

}

End {

    $ErrorActionPreference = $StartErrorActionPreference 
    
}