# The goal for this script is to scan a target IP (?), then list out the open ports in both TCP and UDP
# The associated Process ID should also be displayed next to the open port numbers


Write-Output 'Welcome!'
# Read-Host -Prompt 'Please press Enter to scan the current machine for open TCP and UDP ports: '
# $ErrorActionPreference = 'silentlycontinue'


#If you want to find out which program (process) is listening on a specific port on your computer, 
#use the following command (where 443 is a port number you want to check):
#Get-Process -Id (Get-NetTCPConnection -LocalPort 443).OwningProcess | ft Id, ProcessName, UserName, Path

#list TCP open ports
Write-Output 'Below is a list of open TCP ports and what service they are connected to:'
Get-NetTcpConnection -State Listen,Established | Select-Object LocalAddress,LocalPort,State,@{Name="Process ID";Expression={(Get-Process -Id $_.OwningProcess).Id}},@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},@{Name="Path";Expression={(Get-Process -Id $_.OwningProcess).Path}}| Sort-Object -Property LocalPort | Format-Table
# expression for getting path: @{Name="Path";Expression={(Get-Process -Id $_.OwningProcess).Path}}

#list UDP open ports and what service they are connected to
Write-Output 'Below is a list of open UDP ports and what service they are connected to:'
Get-NetUDPEndpoint | Where-Object {$_.LocalAddress -eq "0.0.0.0"} | Select-Object LocalAddress,LocalPort,@{Name="Process ID";Expression={(Get-Process -Id $_.OwningProcess).Id}},@{Name="Process";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}},@{Name="Path";Expression={(Get-Process -Id $_.OwningProcess).Path}} | Sort-Object -Property LocalPort | Format-Table



# I thought i was doing a port scan at first, don't feel like deleting it yet
Function useless {
foreach ($port in $range) {
    If (($a=Test-NetConnection -Port $port -WarningAction SilentlyContinue).tcpTestSucceeded -eq $true)
    {
        #Write-Output ("TCP port "+$port+" is open! I think")
        $r = "Open"
    } 
    Else {
        $u = new-object system.net.sockets.udpclient
        $u.Client.ReceiveTimeout = 500
        $u.Connect($target,$port)
        #Write-Output 'this should be a udp connection'

        # Send a single byte 0x01
        [void]$u.Send(1,1)
        $l = new-object system.net.ipendpoint([system.net.ipaddress]::Any,0)
        $r = "Filtered"
        try {
          if ($u.Receive([ref]$l)) {
            # We have received some UDP data from the remote host in return
            $r = "Open"
          }
        } catch {
          if ($Error[0].ToString() -match "failed to respond") {
            # We haven't received any UDP data from the remote host in return
            # Let's see if we can ICMP ping the remote host
            if ((Get-wmiobject win32_pingstatus -Filter "address = '$h' and Timeout=1000 and ResolveAddressNames=false").StatusCode -eq 0) {
              # We can ping the remote host, so we can assume that ICMP is not
              # filtered. And because we didn't receive ICMP port-unreachable before,
              # we can assume that the remote UDP port is open
              $r = "Open"
            }
          } elseif ($Error[0].ToString() -match "forcibly closed") {
            # We have received ICMP port-unreachable, the UDP port is closed
            $r = "Closed"
          }
        }
    }

    If ($r=="Open") {
        Write-Output 'Port currently open at port number '+$port
    }
}
}
