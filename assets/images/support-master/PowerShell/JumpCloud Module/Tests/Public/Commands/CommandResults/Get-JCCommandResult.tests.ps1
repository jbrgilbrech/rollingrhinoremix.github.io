Describe -Tag:('JCCommandResult') 'Get-JCCommandResults 1.0' {
    BeforeAll {
        Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null
        $PesterParams_Command1 = Get-JCCommand -CommandID:($PesterParams_Command1.Id)
        If (-not $PesterParams_Command1)
        {
            $PesterParams_Command1 = New-JCCommand @PesterParams_NewCommand1
        }
        # Generate command results of they dont exist
        $CommandResults = Get-JCCommandResult
        If ([System.String]::IsNullOrEmpty($CommandResults) -or $CommandResults.Count -lt $PesterParams_CommandResultCount)
        {
            Add-JCCommandTarget -CommandID $PesterParams_Command1.id -SystemID $PesterParams_SystemLinux._id
            For ($i = 1; $i -le $PesterParams_CommandResultCount; $i++)
            {
                Invoke-JCCommand -trigger:($PesterParams_Command1.trigger)
            }
            While ((Get-JCCommandResult | Where-Object { $_.Name -eq $PesterParams_Command1.name }).Count -ge $PesterParams_CommandResultCount)
            {
                Start-Sleep -Seconds:(1)
            }
            Remove-JCCommandTarget -CommandID $PesterParams_Command1.id -SystemID $PesterParams_SystemLinux._id
        }
    }
    It "Gets all JumpCloud command results" {
        $CommandResults = Get-JCCommandResult
        $CommandResults.count | Should -BeGreaterThan 1
    }
    It "Gets a single JumpCloud command result using -ByID" {
        $SingleCommand = Get-JCCommandResult | Select-Object -Last 1
        $SingleCommandResult = Get-JCCommandResult -ByID $SingleCommand._id
        $SingleCommandResult._id | Should -Not -BeNullOrEmpty
    }
    It "Gets a single JumpCloud command result without declaring -ByID" {
        $SingleCommand = Get-JCCommandResult | Select-Object -Last 1
        $SingleCommandResult = Get-JCCommandResult $SingleCommand._id
        $SingleCommandResult._id | Should -Not -BeNullOrEmpty
    }
    It "Gets a single JumpCloud command result declaring CommandResultID" {
        $SingleCommand = Get-JCCommandResult | Select-Object -Last 1
        $SingleCommandResult = Get-JCCommandResult -CommandResultID $SingleCommand._id
        $SingleCommandResult._id | Should -Not -BeNullOrEmpty
    }
    It "Gets a single JumpCloud command result using -ByID passed through the pipeline" {
        $SingleCommandResult = Get-JCCommandResult | Select-Object -Last 1 | Get-JCCommandResult -ByID
        $SingleCommandResult._id | Should -Not -BeNullOrEmpty
    }
    It "Gets a single JumpCloud command result passed through the pipeline without declaring -ByID" {
        $SingleCommandResult = Get-JCCommandResult | Select-Object -Last 1 | Get-JCCommandResult
        $SingleCommandResult._id | Should -Not -BeNullOrEmpty
    }
}
Describe -Tag:('JCCommandResult') "Get-JCCommandResult 1.4.1" {
    It "Returns the total count of JumpCloud command results" {
        $TotalCount = Get-JCCommandResult -TotalCount
        $TotalCount | Should -BeGreaterThan 0
    }
    It "Uses the -Skip parameter of JumpCloud command results" {
        $TotalCount = Get-JCCommandResult -TotalCount
        $Skip = 2
        $SkipResults = Get-JCCommandResult -skip $Skip
        $Total = $SkipResults.count + $Skip
        $Total | Should -Be $TotalCount
    }
    It "Users the -Limit parameter of JumpCloud command results" {
        $TotalCount = Get-JCCommandResult -TotalCount
        $Limit = '4'
        $LimitTotal = Get-JCCommandResult -limit $Limit
        $LimitTotal.count | Should -Be $TotalCount

    }
}
Describe -Tag:('JCCommandResult') "Get-JCCommandResult 1.4.2" {
    It "Returns the max results" {
        $TotalCount = Get-JCCommandResult -TotalCount
        $MaxResults = $TotalCount - 1
        $Results = Get-JCCommandResult -MaxResults $MaxResults
        $UniqueResults = $Results | Select-Object -Property _id -Unique
        $UniqueResults.count | Should -Be $MaxResults
    }
    It "Returns the max results using skip" {
        $TotalCount = Get-JCCommandResult -TotalCount
        $MaxResults = $TotalCount - 2
        $Results = Get-JCCommandResult -MaxResults $MaxResults -Skip 1
        $UniqueResults = $Results | Select-Object -Property _id -Unique
        $UniqueResults.count | Should -Be $MaxResults
    }
}
Describe -Tag:('JCCommandResult') "Get-JCCommandResult 1.5.0" {
    It "Returns a command result with the SystemID" {
        $CommandResult = Get-JCCommandResult -MaxResults 1
        $VerifySystemID = Get-JCSystem -SystemID $CommandResult.SystemID
        $CommandResult.system | Should -Be $VerifySystemID.displayname
    }
    It "Returns a command result -byID with the SystemID" {
        $CommandResult = Get-JCCommandResult -MaxResults 1 | Get-JCCommandResult -ByID
        $VerifySystemID = Get-JCSystem -SystemID $CommandResult.SystemID
        $CommandResult.system | Should -Be $VerifySystemID.displayname
    }
}
