
<#PSScriptInfo

.VERSION 0.1.0

.GUID 36405065-6970-4852-94ce-0cddf2898d29

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT

.TAGS ctx

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Created [03/11/2021_19:33] Initital Script Creating

.PRIVATEDATA

#>

#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor

<# 

.DESCRIPTION 
 Return details about machine catalogs 

#> 



Function Get-CTXAPI_MachineCatalog {
<#
.SYNOPSIS
Return details about machine catalogs

.DESCRIPTION
Return details about machine catalogs

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_MachineCatalog

#>
	[Cmdletbinding()]
	[OutputType([System.Object[]])]
	PARAM(
		[Parameter(Mandatory = $true)]
		[PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

	(Invoke-RestMethod -Uri 'https://api.cloud.com/cvad/manage/MachineCatalogs/' -Method get -Headers $APIHeader.headers).items | ForEach-Object {
		Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/MachineCatalogs/$($_.id)" -Method Get -Headers $APIHeader.headers
	}

} #end Function