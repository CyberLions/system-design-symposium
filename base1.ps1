#If you want to find out which program (process) is listening on a specific port on your computer, 
#use the following command (where 443 is a port number you want to check):
Get-Process -Id (Get-NetTCPConnection -LocalPort 443).OwningProcess | ft Id, ProcessName, UserName, Path



#list TCP open ports
Get-NetTcpConnection -State Listen | Select-Object LocalAddress,LocalPort| Sort-Object -Property LocalPort | Format-Table


#list UDP open ports and what service they are connected to
Get-NetUDPEndpoint | Where {$_.LocalAddress -eq "0.0.0.0"} | select LocalAddress,LocalPort,@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}}

