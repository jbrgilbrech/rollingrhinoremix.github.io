Function Get-JCCommandTarget
{
    [CmdletBinding(DefaultParameterSetName = 'Systems')]
    param (

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Systems', Position = 0, HelpMessage = 'The id value of the JumpCloud command. Use the command ''Get-JCCommand | Select-Object _id, name'' to find the "_id" value for all the JumpCloud commands in your tenant.')]
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Groups', Position = 0, HelpMessage = 'The id value of the JumpCloud command. Use the command ''Get-JCCommand | Select-Object _id, name'' to find the "_id" value for all the JumpCloud commands in your tenant.')]
        [Alias('_id', 'id')]
        [String]$CommandID,

        [Parameter(ParameterSetName = 'Groups', HelpMessage = 'A switch parameter to display any System Groups associated with a command.')]
        [switch]$Groups

    )

    begin
    {

        Write-Verbose 'Verifying JCAPI Key'
        if ($JCAPIKEY.length -ne 40) {Connect-JConline}

        Write-Verbose 'Populating API headers'
        $hdrs = @{

            'Content-Type' = 'application/json'
            'Accept'       = 'application/json'
            'X-API-KEY'    = $JCAPIKEY

        }

        if ($JCOrgID)
        {
            $hdrs.Add('x-org-id', "$($JCOrgID)")
        }


        if ($PSCmdlet.ParameterSetName -eq 'Groups')
        {

            Write-Verbose 'Populating SystemGroupNameHash'
            $SystemGroupNameHash = Get-Hash_ID_SystemGroupName

        }

        if ($PSCmdlet.ParameterSetName -eq 'Systems')
        {

            Write-Verbose 'Populating SystemDisplayNameHash'
            $SystemDisplayNameHash = Get-Hash_SystemID_DisplayName

            Write-Verbose 'Populating SystemIDHash'
            $SystemHostNameHash = Get-Hash_SystemID_HostName

        }


        Write-Verbose 'Populating CommandNameHash'
        $CommandNameHash = Get-Hash_CommandID_Name

        Write-Verbose 'Populating CommandTriggerHash'
        $CommandTriggerHash = Get-Hash_CommandID_Trigger


        [int]$limit = '100'
        Write-Verbose "Setting limit to $limit"

        Write-Verbose 'Initilizing RawResults and resultsArrayList'
        $RawResults = @()
        $resultsArrayList = New-Object System.Collections.ArrayList

        Write-Verbose "parameter set: $($PSCmdlet.ParameterSetName)"


    }

    process
    {

        [int]$skip = 0 #Do not change!
        [int]$count = 0 #Do not change
        Write-Verbose 'Setting skip and count to zero'
        $RawResults = $null

        switch ($PSCmdlet.ParameterSetName)
        {

            Systems
            {

                while ($count -ge $skip)
                {
                    $SystemURL = "$JCUrlBasePath/api/v2/commands/$CommandID/systems?limit=$limit&skip=$skip"


                    Write-Verbose $SystemURL

                    $APIresults = Invoke-RestMethod -Method GET -Uri  $SystemURL  -Header $hdrs -UserAgent:(Get-JCUserAgent)

                    $skip += $limit
                    Write-Verbose "Setting skip to  $skip"

                    $RawResults += $APIresults

                    $count = ($RawResults).Count
                    Write-Verbose "Results count equals $count"

                } #end while

                foreach ($result in $RawResults)
                {

                    $CommandName = $CommandNameHash.($CommandID)
                    $Trigger = $CommandTriggerHash.($CommandID)
                    $SystemID = $result.id
                    $Hostname = $SystemHostNameHash.($SystemID )
                    $Displyname = $SystemDisplayNameHash.($SystemID)

                    $CommandTargetSystem = [pscustomobject]@{

                        'CommandID'   = $CommandID
                        'CommandName' = $CommandName
                        'trigger'     = $Trigger
                        'SystemID'    = $SystemID
                        'DisplayName' = $Displyname
                        'HostName'    = $Hostname

                    }

                    $resultsArrayList.Add($CommandTargetSystem) | Out-Null

                } # end foreach

            } # end Systems switch

            Groups
            {

                while ($count -ge $skip)
                {
                    $SystemGroupsURL = "$JCUrlBasePath/api/v2/commands/$CommandID/systemgroups?limit=$limit&skip=$skip"


                    Write-Verbose $SystemGroupsURL

                    $APIresults = Invoke-RestMethod -Method GET -Uri  $SystemGroupsURL  -Header $hdrs -UserAgent:(Get-JCUserAgent)

                    $skip += $limit
                    Write-Verbose "Setting skip to  $skip"

                    $RawResults += $APIresults

                    $count = ($RawResults).Count
                    Write-Verbose "Results count equals $count"
                } # end while

                foreach ($result in $RawResults)
                {

                    $CommandName = $CommandNameHash.($CommandID)
                    $GroupID = $result.id
                    $GroupName = $SystemGroupNameHash.($GroupID)

                    $Group = [pscustomobject]@{

                        'CommandID'   = $CommandID
                        'CommandName' = $CommandName
                        'GroupID'     = $GroupID
                        'GroupName'   = $GroupName

                    }

                    $resultsArrayList.Add($Group) | Out-Null

                } # end foreach

            } # end Groups switch
        } # end switch
    } # end process

    end
    {

        Return $resultsArrayList
    }
}