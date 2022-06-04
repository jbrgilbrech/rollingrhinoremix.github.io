Describe -Tag:('JCOnline-MSP') 'Connect-JCOnline Tests' {
    BeforeAll {
        $StartingApiKey = If (-not [System.String]::IsNullOrEmpty($env:JCApiKey)) { $env:JCApiKey }
        $StartingOrgId = If (-not [System.String]::IsNullOrEmpty($env:JCOrgId)) { $env:JCOrgId }
    }
    Context 'MSP OrgId 1 Tests' {
        It ('Should connect using the JumpCloudApiKey and JumpCloudOrgId parameters.') {
            $Connect = Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKeyMsp) -JumpCloudOrgId:($PesterParams_OrgIDMsp1) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp1 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp1
        }
        It ('Should connect using the JumpCloudApiKey parameter.') {
            $Connect = Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKeyMsp) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp1 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp1
        }
        It ('Should connect using the JumpCloudOrgId parameter.') {
            $Connect = Connect-JCOnline -JumpCloudOrgId:($PesterParams_OrgIDMsp1) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp1 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp1
        }
        It('Should connect without parameters using the previously set env:jc* parameters.') {
            $Connect = Connect-JCOnline -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp1 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
        }
    }
    Context 'MSP OrgId 2 Tests' {
        It ('Should connect using the JumpCloudApiKey and JumpCloudOrgId parameters.') {
            $Connect = Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKeyMsp) -JumpCloudOrgId:($PesterParams_OrgIDMsp2) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp2 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp2
        }
        It ('Should connect using the JumpCloudApiKey parameter.') {
            $Connect = Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKeyMsp) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp2 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp2
        }
        It ('Should connect using the JumpCloudOrgId parameter.') {
            $Connect = Connect-JCOnline -JumpCloudOrgId:($PesterParams_OrgIDMsp2) -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp2 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $PesterParams_OrgIDMsp2
        }
        It('Should connect without parameters using the previously set env:jc* parameters.') {
            $Connect = Connect-JCOnline -force
            $PesterParams_ApiKeyMsp | Should -Be $env:JCApiKey
            $PesterParams_OrgIDMsp2 | Should -Be $env:JCOrgId
            #  $Connect.JCOrgId | Should -Be $env:JCOrgId
        }
    }
    AfterAll {
        Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null
    }
}
