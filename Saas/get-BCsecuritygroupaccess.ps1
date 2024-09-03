<#
 .Synopsis
  Function for retrieving securityGroup Access from an online Business Central environment
 .Description
  Function for retrieving securityGroup Access from an online Business Central environment
  Wrapper for https://learn.microsoft.com/fr-fr/dynamics365/business-central/dev-itpro/administration/administration-center-api_environment_settings#get-security-group
 .Parameter bcAuthContext
  Authorization Context created by New-BcAuthContext.
 .Parameter applicationFamily
  Application Family in which the environment is located. Default is BusinessCentral.
 .Parameter environment
  Environment from which you want to return the SecurityGroup Access.
 .Parameter apiVersion
  API version. Default is v2.20. for admin.
 .Example
  $authContext = New-BcAuthContext -includeDeviceLogin
 Get-BcSecurityGroupAccess -bcAuthContext $authContext -environment "Sandbox" 
#>
function Get-BcSecurityGroupAccess {
    Param(
        [Parameter(Mandatory = $true)]
        [Hashtable] $bcAuthContext,
        [string] $applicationFamily = "BusinessCentral",
        [Parameter(Mandatory = $true)]
        [string] $environment,
        [string] $apiVersion = "v2.20"
    )

    $telemetryScope = InitTelemetryScope -name $MyInvocation.InvocationName -parameterValues $PSBoundParameters -includeParameters @()
    try {

        $bcAuthContext = Renew-BcAuthContext -bcAuthContext $bcAuthContext
        $bearerAuthValue = "Bearer $($bcAuthContext.AccessToken)"
        $headers = @{ "Authorization" = $bearerAuthValue }
        try {
            (Invoke-RestMethod -Method Get -UseBasicParsing -Uri "$($bcContainerHelperConfig.apiBaseUrl.TrimEnd('/'))/admin/$apiVersion/applications/$applicationFamily/environments/$environment/settings/securitygroupaccess" -Headers $headers)#.Value
        }
        catch {
            throw (GetExtendedErrorMessage $_)
        }
    }
    catch {
        TrackException -telemetryScope $telemetryScope -errorRecord $_
        throw
    }
    finally {
        TrackTrace -telemetryScope $telemetryScope
    }
}
Export-ModuleMember -Function  Get-BcSecurityGroups -Alias  Get-BcSecurityGroups