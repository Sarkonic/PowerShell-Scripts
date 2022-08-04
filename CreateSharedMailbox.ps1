New-Mailbox -Shared -Name "Test@email.net" -DisplayName "Test" -Alias Test  
Set-Mailbox -Identity test@email.net -GrantSendOnBehalfTo Technology  
Add-MailboxPermission -Identity test@email.net -User Technology -AccessRights FullAccess -InheritanceType All 
Add-ADPermission –Identity “test@email.net” -User Technology -ExtendedRights “Send-As” -InheritanceType All
