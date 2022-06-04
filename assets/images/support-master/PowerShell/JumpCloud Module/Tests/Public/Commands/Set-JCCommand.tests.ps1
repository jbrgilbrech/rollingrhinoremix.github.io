Describe -Tag:('JCCommand') "Set-JCCommand 1.7" {
    BeforeAll { Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null }
    It "Updates the command" {
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -command "Updated command"
        $CmdUpdate.command | Should -Be "Updated command"
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -command "Not updated command"

    }

    It "Updates the launchType to manual" {
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -launchType manual
        $CmdUpdate.launchType | Should -Be "manual"
    }

    It "Updates the launchType to trigger" {
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -launchType trigger -trigger "pesterTrigger"
        $CmdUpdate.launchType | Should -Be "trigger"
        $CmdUpdate.trigger | Should -Be "pesterTrigger"
    }

    It "Updates the name" {
        $CmdQuery = Get-JCCommand -CommandID $PesterParams_Command3.id
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -name "Updated name"
        $CmdUpdate.name | Should -Be "Updated Name"
        $SetBack = Set-JCCommand -CommandID $PesterParams_Command3.id -name $CmdQuery.name

    }

    It "Updates the timeout" {
        $CmdQuery = Get-JCCommand -CommandID $PesterParams_Command3.id
        $CmdUpdate = Set-JCCommand -CommandID $PesterParams_Command3.id -timeout "200"
        $CmdUpdate.timeout | Should -Be "200"
        $SetBack = Set-JCCommand -CommandID $PesterParams_Command3.id -timeout $CmdQuery.timeout
    }
}
