# The goal for this script is to scan a target IP, then list out the open ports in both TCP and UDP
# The associated Process ID should also be displayed next to the open port numbers


Write-Output 'Welcome!'
$target = Read-Host -Prompt 'Please enter the target address you would like to scan: '
Write-Output $target
$range = 1..254
$ErrorActionPreference = 'silentlycontinue'
Get-NetTcpConnection -State Listen | Select-Object LocalAddress,LocalPort| Sort-Object -Property LocalPort 
#port-scan-udp-tcp($target)
#$s = ''

# plan is to make a nice big function that handles the port scans. 
Function port-scan-udp-tcp {
    Param($target)
    if(!$target) {
        Write-Output 'Make sure to enter an address to target'
        return
    }
}
