<#
.SYNOPSIS
    Automatic Enrollment to Defender is enabled for Android Devices
#>

function Test-Assessment-24871 {
    [ZtTest(
    	Category = 'Devices',
    	ImplementationCost = 'Low',
    	Pillar = 'Devices',
    	RiskLevel = 'High',
    	SfiPillar = 'Protect tenants and isolate production systems',
    	TenantType = ('Workforce'),
    	TestId = 24871,
    	Title = 'Automatic Enrollment to Defender is enabled for Android Devices  ',
    	UserImpact = 'Low'
    )]
    [CmdletBinding()]
    param()

    Write-PSFMessage '🟦 Start' -Tag Test -Level VeryVerbose

    #region Data Collection
    $activity = "Checking that Automatic Enrollment to Defender is enabled for Android Devices "
    Write-ZtProgress -Activity $activity

    # Query 1: All android Wi-Fi configuration profiles
    $mobileThreatDefenseConnectorUri = "deviceManagement/mobileThreatDefenseConnectors/fc780465-2017-40d4-a0c5-307022471b92"
    $mobileThreatDefenseConnector = Invoke-ZtGraphRequest -RelativeUri $mobileThreatDefenseConnectorUri -ApiVersion beta

    #region Assessment Logic
    $passed = $mobileThreatDefenseConnector.partnerState -eq 'enabled' -and $mobileThreatDefenseConnector.androidEnabled -eq $true

    if ($passed) {
        $testResultMarkdown = "Mobile Threat Defense Connector is enabled and Android enrollment is active.`n`n%TestResult%"
    }
    else {
        $testResultMarkdown = "Connector is disabled or Android enrollment is not enabled.`n`n%TestResult%"
    }
    #endregion Assessment Logic

    #region Report Generation
    # Build the detailed sections of the markdown

    # Define variables to insert into the format string
    $reportTitle = "Android Mobile Threat Defense status"
    $formatTemplate = @'

## {0}

| Partner State | Android Enrollment |
| :------------ | :----------------- |
| {1} | {2} |

'@

    $partnerState = if ($mobileThreatDefenseConnector.partnerState -eq 'enabled') {
        '✅ Enabled'
    }
    else {
        '❌ Disabled'
    }

    $androidEnabled = if ($mobileThreatDefenseConnector.androidEnabled) {
        '✅ Enabled'
    }
    else {
        '❌ Disabled'
    }

    # Format the template by replacing placeholders with values
    $mdInfo = $formatTemplate -f $reportTitle, $partnerState, $androidEnabled


    # Replace the placeholder in the test result markdown with the generated details
    $testResultMarkdown = $testResultMarkdown -replace "%TestResult%", $mdInfo
    #endregion Report Generation

    $params = @{
        TestId             = '24871'
        Title              = "Automatic Enrollment to Defender is enabled for Android Devices "
        Status             = $passed
        Result             = $testResultMarkdown
    }

    Add-ZtTestResultDetail @params
}
