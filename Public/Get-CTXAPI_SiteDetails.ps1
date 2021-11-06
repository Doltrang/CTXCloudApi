﻿
<#PSScriptInfo

.VERSION 0.1.0

.GUID d52798b4-350d-491e-bd04-dea52b1ef49c

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
Created [03/11/2021_19:34] Initial Script Creating

.PRIVATEDATA

#>

<#

.DESCRIPTION
 Return details about your farm / site

#>


<#
.SYNOPSIS
Return details about your farm / site

.DESCRIPTION
Return details about your farm / site

.PARAMETER APIHeader
Use Connect-CTXAPI to create headers

.EXAMPLE
Get-CTXAPI_SiteDetail -APIHeader $APIHeader

#>
Function Get-CTXAPI_SiteDetails {
    [Cmdletbinding()]
    [OutputType([System.Object[]])]
    PARAM(
        [Parameter(Mandatory = $true)]
        [PSTypeName('CTXAPIHeaderObject')]$APIHeader	)

    Invoke-RestMethod -Uri "https://api.cloud.com/cvad/manage/Sites/$($APIHeader.headers.'Citrix-InstanceId')" -Method get -Headers $APIHeader.headers



} #end Function
