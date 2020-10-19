#Get all files of .log inside the directory.
$logdirectory = "C:\inetpub\wwwroot\SquaredUpv4\Transient\Log"
Get-ChildItem $logdirectory -Filter *.log | 
Foreach-Object {
	$users = @()
	
	#Getting the date from the file name
	$temp1 = $_.ToString().Split("\\")
	$temp2 = $temp1[$temp1.length - 1].Split(".")
	$name = $temp2[0].Replace("rolling-", "")
	
	$year = $name.Substring(0, 4)
    $month = $name.Substring(4, 2)
    $day = $name.Substring(6, 2)
	
	#Display which log file is being checked.
	Write-host "Log of"$day"/"$month"/"$year"`n"

    $x = Get-Content $_.FullName
    [array]::Reverse($x)

	foreach($line in $x) {
		#Check to find the correct log lines.
		if($line.Contains("DecomposedUsername")){
			if(!$line.Contains("Expiry")){
				if(!$line.Contains("SessionId")){
				
					$split = $line.Split("""")
                    $split2 = $line.Split()
					$usernameTime = $split[1] + " " + $split2[1]
                    $username = $split[1]
					
					#Check if the username has already been found logged in.
					if(!$users.Contains($username))
					{
						$users = $users + $username
						
					}
					Write-host $usernameTime
				}
			}			
			
		}
	}
	#Display how many users were logged in on that day.
	Write-host "`nUnique Users ="$users.length"`n"
}