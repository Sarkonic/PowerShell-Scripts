<#
template to enable a user for S4B. 
#>
#change these variables
#--------------------------------------
$fandlname = "fname lname"
$upn = "username@domain.net"
$lineURI = "tel:xxxxx"
$vp = "US-KY-Branchname-International"
$dp = "US-KY-Branchname"
#--------------------------------------
Enable-CsUser -Identity $fandlname -RegistrarPool pool.domain -SipAddressType SAMAccountName -SipDomain domain
$CSUser = get-csuser $upn
$CSUser | set-csuser -EnterpriseVoiceEnabled $True -LineUri $LineURI
$CSUser | grant-csvoicePolicy -PolicyName $vp
$CSUser | grant-csDialPlan -PolicyName $dp
