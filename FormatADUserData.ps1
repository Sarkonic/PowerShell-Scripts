add-type -AssemblyName System.Web

$givenname = ""
$surname = ""
#create csv file
Add-Content -Path "C:\temp\userexport.csv" -Value '"samaccountname","password","givenname","surname","OU"'
#loop through users.txt in the format of just their first and last name
ForEach ($user in (Get-Content C:\temp\users.txt)){
    $givenname = $user.split(" ")[0]
    $surname = $user.split(" ")[1]
    $password = [System.Web.Security.Membership]::GeneratePassword(8,2)
    $samaccountname = $givenname[0]+$surname
    $OU = """OU=Container","OU=Container","OU=Company","DC=domain","DC=local""" -join ','


    Add-Content -Path "C:\temp\userexport.csv" -Value "$samaccountname,$password,$givenname,$surname,$OU"

}
