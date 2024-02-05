$SEARCH = 'chrome$'
$INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
$INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
$RESULT = $INSTALLED | ?{ $_.DisplayName -ne $null } | Where-Object {$_.DisplayName -match $SEARCH }
$UNINSTALL_COMMAND=(($RESULT.UninstallString -split '\"')[1])
$UNINSTALL_ARGS=(($RESULT.UninstallString -split '\"')[2]) + ' --force-uninstall'
Start-Process $UNINSTALL_COMMAND -ArgumentList $UNINSTALL_ARGS -Wait