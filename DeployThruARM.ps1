#Connect to your Azure account
Add-AzureRmAccount 

#Select your subscription if you have more than one
#Select-AzureRmSubscription -SubscriptionId "Your subcription ID here"

#Create a GUID for the job
$JobGUID = [System.Guid]::NewGuid().toString()

#Set the parameter values for the template - edit the parameters
$Params = @{
    "accountName" = "MyAccount2" ;
    "regionId" = "Japan East";
	"userName" = "Your UserName"; 
	"password" = "Your password";
}

$TemplateURI = "https://raw.githubusercontent.com/krishnakanike/ARMTemplates-/master/DMZ_NSG_ARMTemplate.json"
New-AzureRMResourceGroupDeployment -TemplateParameterObject $Params -ResourceGroupName "krishnadeploy1" -TemplateUri $TemplateURI

