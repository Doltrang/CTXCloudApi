
<#PSScriptInfo

.VERSION 1.0.0

.GUID c910816d-788d-4e5f-b405-cb9f898bb106

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS Citrix

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [17/04/2021_09=58] Initital Script Creating

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 add stand alone box to catalog 

#> 

Param()


Function Add-CTXAPI_MachineToCatalog {
	PARAM(
		[Parameter(Mandatory = $true, Position = 0)]
		[ValidateNotNullOrEmpty()]
		[string]$CustomerId,
		[Parameter(Mandatory = $true, Position = 1)]
		[ValidateNotNullOrEmpty()]
		[string]$SiteId,
		[Parameter(Mandatory = $true, Position = 2)]
		[ValidateNotNullOrEmpty()]
		[string]$ApiToken,
		[Parameter(Mandatory = $true, Position = 3)]
		[ValidateNotNullOrEmpty()]
		[string]$CatalogNameORID,
		[Parameter(Mandatory = $true, Position = 4)]
		[ValidateNotNullOrEmpty()]
		[string]$MachineName
	)

	if ($MachineName.split('\')[1] -like $null) { Write-Error 'MachineName needs to be in the format DOMAIN\Hostname'; halt }

	$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)" }
	$headers += @{'Citrix-CustomerId' = $customerId }
	$headers += @{Accept = 'application/json' }



	$body = @{MachineName = $MachineName } 
	Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$CatalogNameORID/machines" -Headers $headers -Method Post -Body ($body | ConvertTo-Json) -ContentType 'application/json' | Select-Object StatusCode,StatusDescription


} #end Function
