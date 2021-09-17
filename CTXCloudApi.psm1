$global:RegistrationState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Registered'
		2 = 'Unregistered'
	}
$global:ConnectionState = [PSCustomObject]@{
		0 = 'Unknown'
		1 = 'Connected'
		2 = 'Disconnected'
		3 = 'Terminated'
		4 = 'PreparingSession'
		5 = 'Active'
		6 = 'Reconnecting'
		7 = 'NonBrokeredSession'
		8 = 'Other'
		9 = 'Pending'
	}
$global:ConnectionFailureType = [PSCustomObject]@{
		0 = 'None'
		1 = 'ClientConnectionFailure'
		2 = 'MachineFailure'
		3 = 'NoCapacityAvailable'
		4 = 'NoLicensesAvailable'
		5 = 'Configuration'
	}
$global:SessionFailureCode = [PSCustomObject]@{
		0   = 'Unknown'
		1   = 'None'
		2   = 'SessionPreparation'
		3   = 'RegistrationTimeout'
		4   = 'ConnectionTimeout'
		5   = 'Licensing'
		6   = 'Ticketing'
		7   = 'Other'
		8   = 'GeneralFail'
		9   = 'MaintenanceMode'
		10  = 'ApplicationDisabled'
		11  = 'LicenseFeatureRefused'
		12  = 'NoDesktopAvailable'
		13  = 'SessionLimitReached'
		14  = 'DisallowedProtocol'
		15  = 'ResourceUnavailable'
		16  = 'ActiveSessionReconnectDisabled'
		17  = 'NoSessionToReconnect'
		18  = 'SpinUpFailed'
		19  = 'Refused'
		20  = 'ConfigurationSetFailure'
		21  = 'MaxTotalInstancesExceeded'
		22  = 'MaxPerUserInstancesExceeded'
		23  = 'CommunicationError'
		24  = 'MaxPerMachineInstancesExceeded'
		25  = 'MaxPerEntitlementInstancesExceeded'
		100 = 'NoMachineAvailable'
		101 = 'MachineNotFunctional'
	}

#region color
$global:colour1 = '#0D2E3F'
$global:colour2 = '#FFB143'

$global:TableSettings = @{
		Style          = 'cell-border'
		HideFooter     = $true
		OrderMulti     = $true
		TextWhenNoData = 'No Data to display here'
        EnableScroller = $true
        FixedHeader    = $true
	}

$global:SectionSettings = @{
	BackgroundColor       = 'grey'
	CanCollapse           = $true
	HeaderBackGroundColor = $colour1
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $colour2
    HeaderTextSize        = '10'
    BorderRadius          = '15px'
}

$global:TableSectionSettings = @{
	BackgroundColor       = 'white'
	CanCollapse           = $true
	HeaderBackGroundColor = $colour2
	HeaderTextAlignment   = 'center'
	HeaderTextColor       = $colour1
	HeaderTextSize        = '10'
}
#endregion


$Global:Logourl = 'https://ioco.tech/wp-content/uploads/2020/03/ioco-logo.png'


# Dot source public/private functions
$publicFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Public/*.ps1'
$privateFunctionsPath = Join-Path -Path $PSScriptRoot -ChildPath 'Private/*.ps1'
$public = @(Get-ChildItem -Path $publicFunctionsPath -Recurse -ErrorAction Stop)
$private = @(Get-ChildItem -Path $privateFunctionsPath -Recurse -ErrorAction Stop)
foreach ($file in @($public + $private)) {
	try {
		. $file.FullName
	} catch {
		throw "Unable to dot source [$($file.FullName)]"
	}
}
Export-ModuleMember -Function $public.BaseName