<#
SLA must be made off of an existing Enterprise Voice User, so we create the user first and and create them as 
as an SLA Group. Users (aka delegates) can then be added. This particualr instance is a global SLA group, so the 
voice and dial plan is set as Stanfordas there is no Global dial plan.
#>

#Set the S4B Enterprise Voice User attributes
#--------------------------------------------------------------------------------
$FirstName="Saturday" ; $LastName="";
$LineUri="tel:+10999"  		
$vp="US-KY-Voice-Plan"   
$dp="US-KY-Dial-Plan" 		
#--------------------------------------------------------------------------------


#set the AD User Attributes and point to SLA OU
#--------------------------------------------------------------------------------
#SLA user accounts are created in this OU
$SLA_OU_path="ou=container,dc=domain,dc=local"
$spwd=convertto-securestring "XXXXXXXX" -AsPlainText -force
$SamAccountName="SLA"+$FirstName+$LastName
$upn=$SamAccountName+"@email.net"
$sipid="sip:"+$upn
$DisplayName=$FirstName + " " + $LastName + " SLA"
$Name=$DisplayName
#---------------------------------------------------------------------------------


#Create SLA Group in AD, enable in S4B and add attributes, set the SLA configuration 
#to show busy when exceeding max num of calls, and loop through a txt file of delegates
#in the format of username@fsnb.net as I'm prepending the "sip:" part
#---------------------------------------------------------------------------------
#Create the new AD object user with the above paramters we have made
new-aduser -GivenName $FirstName -SurName $LastName -SamAccountName $SamAccountName -DisplayName $DisplayName -UserPrincipalName $upn -Accountpassword $spwd -Name $Name -ChangePasswordAtLogon $False -CannotChangePassword $True -PasswordNeverExpires $True -Path $SLA_OU_path -enabled $True
Start-Sleep 3

enable-csuser -Identity $upn -RegistrarPool lex-sfb-pool1.fsnb.net -SipAddressType UserPrincipalName
Start-Sleep 3

#create the CS User in S4B, enable for Enterprise Voice, and add the LineURI, and grant vp/dp
$CSUser=get-csuser $upn
$CSUser|set-csuser -EnterpriseVoiceEnabled $True -LineUri $LineUri
$CSUser|grant-csvoicePolicy -PolicyName $vp
$CSUser|grant-csDialPlan -PolicyName $dp

start-sleep 90
Set-CsSlaConfiguration -Identity $sipid -BusyOption BusyOnBusy -MaxNumberOfCalls 4

$txt_of_delegates = Get-Content C:\temp\delegates.txt
ForEach ($user in $txt_of_delegates ) { Add-CsSlaDelegates $sipid -Delegate "sip:$user" }  
#---------------------------------------------------------------------------------
