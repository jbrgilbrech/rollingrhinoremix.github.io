Describe -Tag:('JCBackupOrg') "Backup-JCOrganization" {
    BeforeAll {
        Connect-JCOnline -JumpCloudApiKey:($PesterParams_ApiKey) -force | Out-Null
    }
    # Currently skipping this test, it's redundant
    It "Backs up JumpCloud Org without associations" {
        # Get valid target types for the backup
        $ValidTargetTypes = (Get-Command Backup-JCOrganization -ArgumentList:($Type.value)).Parameters.Type.Attributes.ValidValues
        $ValidTargetTypes = Get-Random $ValidTargetTypes -count 2
        # Create a backup
        $Backup = Backup-JCOrganization -Path ./ -Type:($ValidTargetTypes) -PassThru
        # From the output of the command, set the expected .zip output
        $zipArchive = Get-Item "$($Backup.backupLocation.FullName).zip"
        # Expand the Archive
        Expand-Archive -Path "$zipArchive" -DestinationPath ./
        # Get child items from the backup directory
        $backupChildItem = Get-ChildItem $Backup.backupLocation.FullName | Where-Object { $_ -notmatch 'Manifest' }
        # verify that the object backup files exist
        foreach ($file in $backupChildItem | Where-Object { $_ -notmatch 'Association' })
        {
            # Only valid target types should exist in the backup directory
            $file.BaseName -in $ValidTargetTypes | Should -BeTrue
        }
        # verify that each file is not null or empty
        foreach ($item in $backupChildItem)
        {
            Get-Content $item.FullName -Raw | Should -Not -BeNullOrEmpty
        }
        # Check the Manifest file:
        $manifest = Get-ChildItem $Backup.backupLocation.FullName | Where-Object { $_ -match 'Manifest' } 
        $manifestContent = Get-Content $manifest.Fullname | ConvertFrom-Json
        $manifestFiles = $manifestContent.result | Where-Object { $_ -notmatch 'Association' }
        # $manifestAssociationFiles = $manifestContent.result | Where-Object { $_ -match 'Association' }

        foreach ($file in $manifestFiles)
        {
            # Manifest Results should contain valid types
            $file.type -in $ValidTargetTypes | Should -BeTrue
            # Backup Files should contain file sin results manifest
            $backupChildItem.Name -match "$($file.type)" | Should -BeTrue
        }
        ($Backup.backupLocation.Parent.EnumerateFiles() | Where-Object { $_.Name -match "$($Backup.backupLocation.BaseName).zip" }) | Should -BeTrue
        $zipArchive | Remove-Item -Force
        $Backup.backupLocation | Remove-Item -Recurse -Force
    }
    It "Backs up JumpCloud Org with specific params using the CSV parameter and Associations" {
        # Get valid target types for the backup
        $ValidTargetTypes = (Get-Command Backup-JCOrganization -ArgumentList:($Type.value)).Parameters.Type.Attributes.ValidValues
        $ValidTargetTypes = Get-Random $ValidTargetTypes -count 2
        # Create a backup
        $Backup = Backup-JCOrganization -Path ./ -Type:($ValidTargetTypes) -PassThru -Format:('csv') -Association
        # From the output of the command, set the expected .zip output
        $zipArchive = Get-Item "$($Backup.BackupLocation.FullName).zip"
        # Expand the Archive
        Expand-Archive -Path "$zipArchive" -DestinationPath ./
        # Get child items from the backup directory
        $backupChildItem = Get-ChildItem $Backup.BackupLocation.FullName | Where-Object { $_ -notmatch 'Manifest' }
        # verify that the object backup files exist
        foreach ($file in $backupChildItem | Where-Object { $_ -notmatch 'Association' })
        {
            # Only valid target types should exist in the backup directory
            $file.BaseName -in $ValidTargetTypes | Should -BeTrue
        }
        # verify that each file is not null or empty
        foreach ($item in $backupChildItem)
        {
            # Files should be of type csv
            $item.extension | Should -Be ".csv"
            Get-Content $item.FullName -Raw | Should -Not -BeNullOrEmpty
        }
        # Check the Manifest file:
        $manifest = Get-ChildItem $Backup.BackupLocation.FullName | Where-Object { $_ -match 'Manifest' }
        $manifestContent = Get-Content $manifest.Fullname | ConvertFrom-Json
        $manifestFiles = $manifestContent.result | Where-Object { $_ -notmatch 'Association' }
        # $manifestAssociationFiles = $manifestContent.result | Where-Object { $_ -match 'Association' }

        foreach ($file in $manifestFiles)
        {
            # Manifest Results should contain valid types
            $file.type -in $ValidTargetTypes | Should -BeTrue
            # Backup Files should contain file sin results manifest
            $backupChildItem.Name -match "$($file.type)" | Should -BeTrue
        }
        ($Backup.BackupLocation.Parent.EnumerateFiles() | Where-Object { $_.Name -match "$($Backup.BackupLocation.BaseName).zip" }) | Should -BeTrue
        $zipArchive | Remove-Item -Force
        $Backup.BackupLocation | Remove-Item -Recurse -Force
    }
}
