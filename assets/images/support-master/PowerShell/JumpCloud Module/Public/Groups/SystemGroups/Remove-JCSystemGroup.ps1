Function Remove-JCSystemGroup ()
{
    [CmdletBinding(DefaultParameterSetName = 'warn')]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'warn', Position = 0, HelpMessage = 'The name of the System Group you want to remove.')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'force', Position = 0, HelpMessage = 'The name of the System Group you want to remove.')]
        [Alias('name')]
        [String]$GroupName,

        [Parameter(ParameterSetName = 'force', HelpMessage = 'A SwitchParameter which suppresses the warning message when removing a JumpCloud System Group.')]
        [Switch]$force
    )

    begin

    {
        Write-Debug 'Verifying JCAPI Key'
        if ($JCAPIKEY.length -ne 40) {Connect-JConline}

        Write-Debug 'Populating API headers'
        $hdrs = @{

            'Content-Type' = 'application/json'
            'Accept'       = 'application/json'
            'X-API-KEY'    = $JCAPIKEY

        }

        if ($JCOrgID)
        {
            $hdrs.Add('x-org-id', "$($JCOrgID)")
        }

        Write-Debug 'Initilizing rawResults and results resultsArray'
        $resultsArray = @()


        Write-Debug 'Populating GroupNameHash'
        $GroupNameHash = Get-Hash_SystemGroupName_ID


    }


    process

    {
        if ($PSCmdlet.ParameterSetName -eq 'warn')

        {
            ForEach ($Gname in $GroupName)

            {
                if ($GroupNameHash.containsKey($Gname))

                {
                    $GID = $GroupNameHash.Get_Item($Gname)

                    Write-Warning "Are you sure you want to delete group: $Gname ?" -WarningAction Inquire

                    $URI = "$JCUrlBasePath/api/v2/systemgroups/$GID"

                    $DeletedGroup = Invoke-RestMethod -Method DELETE -Uri $URI -Headers $hdrs -UserAgent:(Get-JCUserAgent)

                    $Status = 'Deleted'

                    $FormattedResults = [PSCustomObject]@{

                        'Name'   = $Gname
                        'Result' = $Status

                    }

                    $resultsArray += $FormattedResults
                }

                else
                {
                    Throw "Group does not exist. Run 'Get-JCGroup -type User' to see a list of all your JumpCloud user groups."
                }
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'force')
        {
            ForEach ($Gname in $GroupName)
            {

                $GID = $GroupNameHash.Get_Item($Gname)

                try
                {
                    $URI = "$JCUrlBasePath/api/v2/systemgroups/$GID"
                    $DeletedGroup = Invoke-RestMethod -Method DELETE -Uri $URI -Headers $hdrs -UserAgent:(Get-JCUserAgent)
                    $Status = 'Deleted'
                }
                catch
                {
                    $Status = $_.ErrorDetails
                }

                $FormattedResults = [PSCustomObject]@{

                    'Name'   = $Gname
                    'Result' = $Status

                }

                $resultsArray += $FormattedResults
            }

        }
    }
    end
    {
        return $resultsArray
    }
}