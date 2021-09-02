
<#PSScriptInfo

.VERSION 1.0.0

.GUID 2771087e-b214-426e-aa65-95c2960ea6f6

.AUTHOR Pierre Smit

.COMPANYNAME iOCO Tech

.COPYRIGHT 

.TAGS citrix

.LICENSEURI 

.PROJECTURI 

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
Created [24/08/2021_10:02] Initital Script Creating

#>

<# 

.DESCRIPTION 
 Run CVAD Tests and results 

#> 

Param()


#Requires -Module ImportExcel
#Requires -Module PSWriteHTML
#Requires -Module PSWriteColor
Function Get-CTXAPI_Tests {
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
                    [switch]$SiteTest = $false,
                    [switch]$HypervisorsTest = $false,	
                    [switch]$DeliveryGroupsTest = $false,
                    [switch]$MachineCatalogsTest = $false,
                    [Parameter(Mandatory = $false, Position = 3)]
					[ValidateSet('Excel', 'HTML')]
					[string]$Export = 'Host',
                	[Parameter(Mandatory = $false, Position = 4)]
					[ValidateScript( { (Test-Path $_) })]
					[string]$ReportPath = $env:temp
				)


$headers = @{
  Authorization = "CwsAuth Bearer=$($ApiToken)"
  'Citrix-CustomerId' = $customerId
  Accept = 'application/json'
}

$data = @()

if ($SiteTest){
Invoke-WebRequest ([string]::Format("https://api-us.cloud.com/cvadapis/sites/{0}/`$test", $siteid)) -Verbose  -Method Post -Headers $headers -ContentType "application/json"
$data += (Invoke-RestMethod "https://api-us.cloud.com/cvadapis/sites/$siteid/TestReport" -Headers $headers).TestResults 
}

if ($HypervisorsTest){
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/hypervisors/$_/TestReport" -Headers $headers).TestResults}
}

if ($DeliveryGroupsTest) {
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data += (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/DeliveryGroups/$_/TestReport" -Headers $headers -Verbose).TestResults}
}

if ($MachineCatalogsTest) {
(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object {Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/`$test" -Method Post -Headers $headers -ContentType 'application/json'}
$data +=  (Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs" -Headers $headers).items.id | ForEach-Object {(Invoke-RestMethod "https://api.cloud.com/cvadapis/$siteid/MachineCatalogs/$_/TestReport" -Headers $headers -Verbose).TestResults}
}

$expandedddata = @()
foreach ($top in $data){
    foreach ($item in $top.TestComponents){
    $expandedddata +=[PSCustomObject]@{
        Test                   = $top.TestName
        TestDescription        = $top.TestDescription
        TestScope              = $top.TestScope
        TestServiceTarget      = $top.TestServiceTarget
        TestComponentStatus    = $top.TestComponentStatus
        FormattedTestEndTime   = $top.FormattedTestEndTime
        TestComponentTarget    = $item.TestComponentTarget
        Explanation            = $item.ResultDetails[0].Explanation
        Serverity              = $item.ResultDetails[0].Serverity
        Action                 = $item.ResultDetails[0].Action
        }
    }
}

$Alldata = @{
    FatalError = $expandedddata | Where-Object {$_.Serverity -like "FatalError"} | Group-Object -Property TestServiceTarget | Select-Object Name,Count | Sort-Object count -Descending
    Error = $expandedddata | Where-Object {$_.Serverity -like "Error"} | Group-Object -Property TestServiceTarget | Select-Object Name,Count | Sort-Object count -Descending
    Alldata = $expandedddata
}


if ($Export -eq 'Excel') { 
    $Alldata.FatalError | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName FatalError 
    $Alldata.Error | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName error 
    $Alldata.Alldata | Export-Excel -Path ($ReportPath + '\Tests-' + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.xlsx') -AutoSize -AutoFilter -WorksheetName Alldata -Show 
} 
if ($Export -eq 'HTML')  {

		$TableSettings = @{
			#Style          = 'stripe'
			Style          = 'cell-border'
			HideFooter     = $true
			OrderMulti     = $true
			TextWhenNoData = 'No Data to display here'
		}

		$SectionSettings = @{
			BackgroundColor       = 'white'
			CanCollapse           = $true
			HeaderBackGroundColor = 'white'
			HeaderTextAlignment   = 'center'
			HeaderTextColor       = 'grey'
		}

		$TableSectionSettings = @{
			BackgroundColor       = 'white'
			HeaderBackGroundColor = 'grey'
			HeaderTextAlignment   = 'center'
			HeaderTextColor       = 'white'
		}
		#endregion 
[string]$HTMLReportname = $ReportPath + "\SiteTests" + (Get-Date -Format yyyy.MM.dd-HH.mm) + '.html'
		$HeadingText = $CustomerId + ' | Report | ' + (Get-Date -Format dd) + ' ' + (Get-Date -Format MMMM) + ',' + (Get-Date -Format yyyy) + ' ' + (Get-Date -Format HH:mm)

		New-HTML -TitleText "$CustomerId Report" -FilePath $HTMLReportname -ShowHTML {
			New-HTMLHeading -Heading h1 -HeadingText $HeadingText -Color Black
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Fatal Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.FatalError }
                New-HTMLSection -HeaderText 'Errors' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $Alldata.Error }
			}
			New-HTMLSection @SectionSettings -Content {
				New-HTMLSection -HeaderText 'Alldata' @TableSectionSettings { New-HTMLTable @TableSettings -DataTable $alldata.Alldata }
			}
        }


$Alldata | Out-GridHtml -DisablePaging -Title 'Citrix Tests' -HideFooter -SearchHighlight -FixedHeader }
if ($Export -eq 'Host')  { $Alldata }


} #end Function
