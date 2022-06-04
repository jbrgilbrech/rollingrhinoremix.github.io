Describe -Tag:('JCCommand') 'Remove-JCCommand 1.2' {
    BeforeAll { Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null }
    It "Creates a new Windows command" {

        $NewCommand = New-JCCommand -commandType windows -name windows_test -command 'dir'

        $CommandRemove = Remove-JCCommand -CommandID $NewCommand._id -force

        $CommandRemove.results | Should -Be 'Deleted'
    }


}
