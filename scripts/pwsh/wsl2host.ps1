$remoteport = bash.exe -c "ip addr show dev eth0 | grep 'inet '"

$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  echo "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}
echo $remoteport
# # Get the name of the WSL distro
# $distroName = Read-Host "Enter the name of the WSL distro:"

# # Get the IP address of the WSL distro
# $ipAddress = (wsl --list --all | Select-String "$distroName").ToString().Split(" ")[-1]

# # Set up the port forward using netsh
# # netsh interface portproxy add v4tov4 listenport=22 connectaddress=$ipAddress connectport=22

# # Confirm that the port forward has been set up
# Write-Host "Port forward for port 22 to $ipAddress has been set up."

#[Ports]

#All the ports you want to forward separated by coma
$ports=@(80,443,22);


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr='0.0.0.0';
$ports_a = $ports -join ",";


# #Remove Firewall Exception Rules
# iex "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

# #adding Exception Rules for inbound and outbound Rules
# iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
# iex "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
}


# netsh interface portproxy add v4tov4 listenport=22 listenaddress=192.168.50.75 connectport=22 connectaddress=172.23.10.196