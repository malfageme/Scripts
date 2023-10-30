
While($true){ [hashtable]$wlan = @{};netsh.exe wlan show interfaces | ForEach-Object{ if( $_ -match '(\w[^:]+):\s+?(\w.*)$' -and ! [string]::IsNullOrEmpty( $matches[2] ) ) { $wlan.Add( $matches[1].Trim() , $matches[2] )}} ; "{0} {1} {2:3} {3:4} {4}" -f (Get-Date -Format G) , $wlan.SSID , $wlan.Channel, $wlan.Signal , ( "$([char]4)" * [int]($wlan.Signal -replace '%') + ( "-" * (100-[int]($wlan.Signal -replace '%')) ) ) ; start-sleep 5 }

