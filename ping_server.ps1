$serverList = Get-Content "C:\path\to\serverlist.txt"

foreach ($server in $serverList) {
$ping = Test-Connection -ComputerName $server -Count 1 -ErrorAction SilentlyContinue
if ($ping) {
Write-Host "$server is up!"
} else {
Write-Host "$server is down."
}
}