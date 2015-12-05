workflow DeployThruARM_WebHookb
{

$uri = "https://s5events.azure-automation.net/webhooks?token=CSoJkZLNOw1NyesTuDu0pOD6DDVbZVt%2bxBUwyaSQNfw%3d"
$headers = @{"From"="usvmatask@microsoft.com";"Date"= get-date}
$parameters = @([pscustomobject]@{ ResourceGroupName = "DMZDemoARMRG";
	ResourceGrpLocation = "Central US";
	ARMTemplateURI = "https://raw.githubusercontent.com/krishnakanike/ARMTemplates-/master/DMZ_NSG_ARMTemplate.json";
	location = "Central US";
	dmzdemofevmName = "dmzdemofevm";
	dmzdemofevmAdminUserName = "demouser";
	dmzdemofevmAdminPassword = "demo@pass1";
	dmzdemoappvmName = "dmzdemoappvm";
	dmzdemoappvmAdminUserName = "demouser";
	dmzdemoappvmAdminPassword = "demo@pass1"; 
	dmzdemodbvmName = "dmzdemodbvm"; 
	dmzdemodbvmAdminUserName = "demouser"; 
	dmzdemodbvmAdminPassword = "demo@pass1";
	dmzdemofevmpipDnsName = "dmzdemofevmdns2";
	dmzdemoappvmpipDnsName = "dmzdemoappvmdns2";
	dmzdemodbvmpipDnsName = "dmzdemodbvmdns2";})   

$Webhookbody = ConvertTo-Json -InputObject $parameters
$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $Webhookbody
$jobId1 = ConvertTo-Json $response

}
