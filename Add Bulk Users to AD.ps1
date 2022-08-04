Import-Module ActiveDirectory

$ADUsers = Import-Csv C:\temp\userexport.csv

# Loop through each row containing user details in the CSV file
foreach ($User in $ADUsers) {

    #Read user data from each field in each row and assign the data to a variable as below
    $username = $User.Samaccountname
    $password = $User.password
    $firstname = $User.givenname
    $lastname = $User.surname
    $OU = $User.OU

    # Check to see if the user already exists in AD
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        Write-Warning "A user account with username $username already exists in Active Directory."
    }
    else {
        New-ADUser `
            -SamAccountName $username `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $OU `
            -AccountPassword (ConvertTo-secureString $password -AsPlainText -Force) -ChangePasswordAtLogon $True

        # If user is created, show message.
        Write-Host "The user account $username is created."
    }
}

Read-Host -Prompt "Press Enter to exit"
