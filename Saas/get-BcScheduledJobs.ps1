<#
 .Synopsis
  Function for retrieving scheduledJobs from an online Business Central environment
 .Description
  Function for retrieving scheduledJobs from an online Business Central environment
  Wrapper for https://learn.microsoft.com/fr-fr/dynamics365/business-central/dev-itpro/administration/api/dynamics_scheduledjob_get
 .Parameter bcAuthContext
  Authorization Context created by New-BcAuthContext.
 .Parameter applicationFamily
  Application Family in which the environment is located. Default is BusinessCentral.
 .Parameter CompanyID
  CompanyID from which you want to return the Package.
 .Parameter environment
  Environment from which you want to return the companies.
 .Parameter apiVersion
  API version. Default is v2.0. for automation.
 .Example
  $authContext = New-BcAuthContext -includeDeviceLogin
  Get-BcscheduledJobs -bcAuthContext $authContext -environment "Sandbox" -CompanyID {CompanyID}
#>
function Get-BcscheduledJobs {
    Param(
        [Parameter(Mandatory = $true)]
        [Hashtable] $bcAuthContext,
        [string] $applicationFamily = "BusinessCentral",
        [Parameter(Mandatory = $true)]
        [string] $environment,
        [Parameter(Mandatory = $true)]
        [string] $CompanyID,
        [string] $apiVersion = "v2.0"
    )

    $telemetryScope = InitTelemetryScope -name $MyInvocation.InvocationName -parameterValues $PSBoundParameters -includeParameters @()
    try {

        $bcAuthContext = Renew-BcAuthContext -bcAuthContext $bcAuthContext
        $bearerAuthValue = "Bearer $($bcAuthContext.AccessToken)"
        $headers = @{ "Authorization" = $bearerAuthValue }
        try {
            (Invoke-RestMethod -Method Get -UseBasicParsing -Uri "$($bcContainerHelperConfig.apiBaseUrl.TrimEnd('/'))/$apiVersion/$environment/api/microsoft/automation/$apiVersion/companies(${CompanyID})/scheduledJobs" -Headers $headers).Value
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
Export-ModuleMember -Function  Get-BcscheduledJobs -Alias  Get-BcscheduledJobs