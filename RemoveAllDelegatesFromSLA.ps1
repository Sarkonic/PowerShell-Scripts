$users = Get-CsSlaConfiguration SLASaturday@fsnb.net | select delegates
$i=0
 while ($i -ne $users.Delegates.Count) {
    Remove-CsSlaDelegates SLASaturday@fsnb.net -Delegate $users.Delegates[$i].AbsoluteUri
    $i++
 }
