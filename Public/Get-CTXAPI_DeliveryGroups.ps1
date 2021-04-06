
<#PSScriptInfo

.VERSION 1.0.1

.GUID 1c10d8b3-8ca1-4658-8e1b-fa1a99eaa3db

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
Created [03/04/2021_01:17] Initital Script Creating
Updated [06/04/2021_09:03] Script Fle Info was updated

#> 



<# 

.DESCRIPTION 
get cloud groups

#> 

Param()


Function Get-CTXAPI_DeliveryGroups {
                PARAM(
					[Parameter(Mandatory = $true, Position = 0)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$CustomerId,
					[Parameter(Mandatory = $true, Position = 1)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$SiteId,
                	[Parameter(Mandatory = $true, Position = 2)]
               	 	[ValidateNotNullOrEmpty()]
					[string]$ApiToken)

$headers = @{Authorization = "CwsAuth Bearer=$($ApiToken)"}
$headers += @{
	'Citrix-CustomerId' = $customerId
	Accept              = 'application/json'
}

$Delgroups = @()
(((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups" -Headers $headers).Content | ConvertFrom-Json).items).name | ForEach-Object {
    $DelGroups += ((Invoke-WebRequest "https://api.cloud.com/cvadapis/$siteid/deliverygroups/$_" -Headers $headers).Content | ConvertFrom-Json)
    }
$DelGroups

} #end Function