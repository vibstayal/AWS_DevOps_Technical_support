$token = Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token-ttl-seconds" = "21600"} -Method PUT –Uri http://169.254.169.254/latest/api/token -V

$AccessKeyId = (Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/iam/security-credentials/ad-ssm-role).AccessKeyId
$SecretAccessKey = (Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/iam/security-credentials/ad-ssm-role).SecretAccessKey 
$Token = (Invoke-RestMethod -Headers @{"X-aws-ec2-metadata-token" = $token} -Method GET -Uri http://169.254.169.254/latest/meta-data/iam/security-credentials/ad-ssm-role).Token 

setx AWS_ACCESS_KEY_ID "$AccessKeyId" /M 
setx AWS_SECRET_ACCESS_KEY "$SecretAccessKey" /M 
setx AWS_SESSION_TOKEN $Token /M

$new_entry = $token
$new_path = $new_entry
[Environment]::SetEnvironmentVariable('AWS_SESSION_TOKEN', $new_path,'Machine');

Restart-service AmazonSSMAgent

sleep 120
$State = (get-wmiobject win32_service | where { $_.name -eq 'AmazonSSMAgent'}).state
echo $State
If ($State -ne 'Running' -and $State -ne 'Stopped' ) {
       $ServicePIDe = (get-wmiobject win32_service | where { $_.name -eq 'AmazonSSMAgent'}).processID
       Stop-Process $ServicePIDe -Force
       sleep 20
       Restart-service AmazonSSMAgent
    } elseif ($State -eq 'Stopped') {
	Restart-service AmazonSSMAgent
    } else {
     echo Good   
}

sleep 120
$State = (get-wmiobject win32_service | where { $_.name -eq 'AmazonSSMAgent'}).state
echo $State
If ($State -ne 'Running' -and $State -ne 'Stopped' ) {
       $ServicePIDe = (get-wmiobject win32_service | where { $_.name -eq 'AmazonSSMAgent'}).processID
       Stop-Process $ServicePIDe -Force
       sleep 20
       Restart-service AmazonSSMAgent
    } elseif ($State -eq 'Stopped') {
	Restart-service AmazonSSMAgent
    } else {
     echo Good   
}