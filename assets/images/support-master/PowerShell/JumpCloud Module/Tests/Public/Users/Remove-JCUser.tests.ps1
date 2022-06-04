Describe -Tag:('JCUser') "Remove-JCUser 1.10" {
    BeforeAll { Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null }

    It "Remove-JCUser 1.0" {
        $NewUser = New-RandomUser "PesterTest$(Get-Date -Format MM-dd-yyyy)" | New-JCUser
        $DeleteUser = Remove-JCUser -UserID $NewUser._id -ByID -Force
        $DeleteUser.results | Should -Be 'Deleted'
    }

    It "Removes JumpCloud User by Username and -force" {

        $NewUser = New-RandomUser -domain "pleasedelete" | New-JCUser

        $RemoveUser = Remove-JCUser  -Username $NewUser.username -force

        $RemoveUser.Results | Should -Be 'Deleted'

    }

    It "Removes JumpCloud User by UserID and -force" {

        $NewUser = New-RandomUser -domain "pleasedelete" | New-JCUser

        $RemoveUser = Remove-JCUser  -UserID $NewUser._id -force

        $RemoveUser.Results | Should -Be 'Deleted'

    }

}
