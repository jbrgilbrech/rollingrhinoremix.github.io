Describe -Tag:('JCBackup') "Get-JCBackup 1.5.0" {
    BeforeAll {
        Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null
        If (-not (Get-JCAssociation -Type:('user') -Name:($PesterParams_User1.username) -TargetType:('system') -IncludeNames | Where-Object { $_.TargetName -eq $PesterParams_SystemLinux.displayName }))
        {
            Add-JCAssociation -Type:('user') -Name:($PesterParams_User1.username) -TargetType:('system') -TargetName:($PesterParams_SystemLinux.displayName) -Force
        }
        Add-JCUserGroupMember -GroupName $PesterParams_UserGroup.Name -username $PesterParams_User1.Username
        Add-JCSystemGroupMember -GroupName $PesterParams_SystemGroup.Name -SystemID $PesterParams_SystemLinux._id
    }
    It "Backs up JumpCloud users" {
        Get-JCBackup -All
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudUsers_' }) | Should -BeTrue
        ($Files | Where-Object { $_.Name -match 'JumpCloudSystemUsers_' }) | Should -BeTrue
        ($Files | Where-Object { $_.Name -match 'JumpCloudUserGroupMembers_' }) | Should -BeTrue
        ($Files | Where-Object { $_.Name -match 'JumpCloudSystemGroupMembers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud users" {
        Get-JCBackup -Users
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudUsers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud systems" {
        Get-JCBackup -Systems
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudSystems_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud system users" {
        Get-JCBackup -SystemUsers
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudSystemUsers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud system groups" {
        Get-JCBackup -SystemGroups
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudSystemGroupMembers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud user groups" {
        Get-JCBackup -UserGroups
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudUserGroupMembers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
    It "Backs up JumpCloud users and user groups" {
        Get-JCBackup -Users -UserGroups
        $Files = Get-ChildItem -Path:('JumpCloud*_*.csv')
        ($Files | Where-Object { $_.Name -match 'JumpCloudUsers_' }) | Should -BeTrue
        ($Files | Where-Object { $_.Name -match 'JumpCloudUserGroupMembers_' }) | Should -BeTrue
        $Files | Remove-Item
    }
}
