Describe -Tag:('JCCommand') 'Import-JCCommand 1.1' {
    BeforeAll { Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null }
    It "Imports a JumpCloud command from a long URL" {

        $Command = Import-JCCommand -URL 'https://github.com/TheJumpCloud/support/blob/master/PowerShell/JumpCloud%20Commands%20Gallery/Mac%20Commands/Mac%20-%20Get%20Logged%20In%20Users.md'

        $Command.commandType | Should -Be 'mac'

        Remove-JCCommand -CommandID $Command._id -force

    }

    It "Imports a JumpCloud command from a short URL" {

        $Command = Import-JCCommand -URL 'https://git.io/jccg-Mac-GetLoggedInUsers'

        $Command.commandType | Should -Be 'mac'

        Remove-JCCommand -CommandID $Command._id -force

    }


}
