﻿$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Start-WE_Pre-Sysprep" {
    It "does something useful" {
        $true | Should -Be $false
    }
}