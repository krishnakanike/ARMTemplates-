param(
	[object] $WebhookData	
)
# If runbook was called from Webhook, WebhookData will not be null.
if ($WebhookData -ne $null) {   

    # Collect properties of WebhookData
    $WebhookName    =   $WebhookData.WebhookName
    $WebhookHeaders =   $WebhookData.RequestHeader
    $WebhookBody    =   $WebhookData.RequestBody
		
	# Collect individual headers. VMList converted from JSON.
	$From = $WebhookHeaders.From
    $ParamList = ConvertFrom-Json -InputObject $WebhookBody
    Write-Output "Runbook started from webhook $WebhookName by $From."
	Write-Output "Runbook ParamList from webhook $WebhookName are "
	Write-Output $ParamList
			
	#Set the parameter values required for creation of a Resource group
	$ResourceGroupName = $ParamList.ResourceGroupName
	$ResourceGrpLocation = $ParamList.ResourceGrpLocation
	
	#Set the parameter values for the template - edit the parameters
	$Params = @{
    "location" = $ParamList.location;
	"dmzdemofevmName" = $ParamList.dmzdemofevmName;
	"dmzdemofevmAdminUserName" = $ParamList.dmzdemofevmAdminUserName;
	"dmzdemofevmAdminPassword" = $ParamList.dmzdemofevmAdminPassword;
	"dmzdemoappvmName" = $ParamList.dmzdemoappvmName;
	"dmzdemoappvmAdminUserName" = $ParamList.dmzdemoappvmAdminUserName;
	"dmzdemoappvmAdminPassword" = $ParamList.dmzdemoappvmAdminPassword; 
	"dmzdemodbvmName" = $ParamList.dmzdemodbvmName; 
	"dmzdemodbvmAdminUserName" = $ParamList.dmzdemodbvmAdminUserName; 
	"dmzdemodbvmAdminPassword" = $ParamList.dmzdemodbvmAdminPassword;
	"dmzdemofevmpipDnsName" = $ParamList.dmzdemofevmpipDnsName;
	"dmzdemoappvmpipDnsName" = $ParamList.dmzdemoappvmpipDnsName;
	"dmzdemodbvmpipDnsName" = $ParamList.dmzdemodbvmpipDnsName;
    }
}
 else {
        Write-Error "Runbook mean to be started only from webhook." 
    } 

#The name of the Automation Credential Asset this runbook will use to authenticate to Azure. 
$CredentialAssetName = 'usvmtask@microsoft.com' 

#Get the credential with the above name from the Automation Asset store 
$Cred = Get-AutomationPSCredential -Name $CredentialAssetName 
if(!$Cred) { 
    Throw "Could not find an Automation Credential Asset named '${CredentialAssetName}'. Make sure you have created one in this Automation Account." 
} 

#Connect to your Azure Account 
$Account = Add-AzureRmAccount -Credential $Cred 
if(!$Account) { 
    Throw "Could not authenticate to Azure using the credential asset '${CredentialAssetName}'. Make sure the user name and password are correct." 
} 
 
$TemplateURI = $ParamList.ARMTemplateURI

# Create a new Resource Group
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGrpLocation
Write-Output "Runbook command New-AzureRmResourceGroup with Name $ResourceGroupName and location $ResourceGrpLocation completed"

# Deploy the infrastructure from above paramlist and ARM template URI
New-AzureRMResourceGroupDeployment -TemplateParameterObject $Params -ResourceGroupName $ResourceGroupName -TemplateUri $TemplateURI
Write-Output "Runbook command New-AzureRMResourceGroupDeployment with above ParamList and ARMTemplateURI $TemplateURI completed"

