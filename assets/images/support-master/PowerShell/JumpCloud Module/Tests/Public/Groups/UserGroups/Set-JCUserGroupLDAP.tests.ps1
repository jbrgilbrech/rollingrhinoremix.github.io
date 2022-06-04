Describe -Tag:('JCUserGroupLDAP') 'Set-JCUserGroupLDAP' {
    BeforeAll { Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null }
    It "Enables LDAP for a JumpCloud User Group using GroupName" {

        $NewUserGroup = New-JCUserGroup -GroupName $(New-RandomString 8) | Select-Object -ExpandProperty Name

        $DisableLDAP = Set-JCUserGroupLDAP -GroupName $NewUserGroup -LDAPEnabled $false

        $EnableLDAP = Set-JCUserGroupLDAP -GroupName $NewUserGroup -LDAPEnabled $true

        $EnableLDAP.LDAPEnabled | Should -Be $true

        $UserGroupRemove = Remove-JCUserGroup -GroupName $NewUserGroup -force

    }

    It "Disables LDAP for a JumpCloud User Group using GroupName" {

        $NewUserGroup = New-JCUserGroup -GroupName $(New-RandomString 8) | Select-Object -ExpandProperty Name

        $EnableLDAP = Set-JCUserGroupLDAP -GroupName $NewUserGroup -LDAPEnabled $true

        $DisableLDAP = Set-JCUserGroupLDAP -GroupName $NewUserGroup -LDAPEnabled $false

        $DisableLDAP.LDAPEnabled | Should -Be $false

        $UserGroupRemove = Remove-JCUserGroup -GroupName $NewUserGroup -force

    }

    It "Enables LDAP for a JumpCloud User Group using GroupID" {

        $UserGroup = New-JCUserGroup -GroupName $(New-RandomString 8)

        $EnableLDAP = Set-JCUserGroupLDAP -GroupID $UserGroup.id -LDAPEnabled $true

        $EnableLDAP.LDAPEnabled | Should -Be $true

        $UserGroupRemove = Remove-JCUserGroup -GroupName $UserGroup.name -force

    }

    It "Disables LDAP for a JumpCloud User Group using GroupID" {

        $UserGroup = New-JCUserGroup -GroupName $(New-RandomString 8)

        $EnableLDAP = Set-JCUserGroupLDAP -GroupID $UserGroup.id -LDAPEnabled $true

        $DisableLDAP = Set-JCUserGroupLDAP -GroupID $UserGroup.id -LDAPEnabled $false

        $DisableLDAP.LDAPEnabled | Should -Be $false

        $UserGroupRemove = Remove-JCUserGroup -GroupName $UserGroup.name -force


    }


}
