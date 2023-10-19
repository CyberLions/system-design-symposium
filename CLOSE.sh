DATE=`date +%m-%d-%y@%H)` 
DATE2=`date +%H:%M:%S)` 
RED='\033[0;31m'
NOCOLOR='\033[0m'
mkdir Logs
echo "Welcome\n"
echo "Input open ports by ${RED}FILE${NOCOLOR} or ${RED}INPUT${NOCOLOR}\n"
read file_input
echo "\n"
if [ "$file_input" = "FILE" ]; 
 then
  	echo "Please enter the files path ending in .txt\n"
  	read file_path
  	echo "$file_path Sucessfully Imported!"
  	while IFS= read -r line
		do
		sudo iptables -I INPUT -p tcp --dport "$line" -j ACCEPT
		echo $line "opened"
		done < "$file_path"
	
  	sudo iptables -P INPUT DROP 
  	echo "All other ${RED}INPUT${NOCOLOR} ports closed successfully!"
  	sudo iptables -L
	exit 1


else [ "$file_input" = "INPUT" ]; 
  read -p "Please enter ports number separated by space: " port_num
	#echo $port_num >> "$DATE.txt"
	echo "\n"
	echo "#newrun-""$DATE2" >> "./Logs/$DATE.txt"
	for port in $port_num
		do
		echo $port >> "./Logs/$DATE.txt"
		done
	echo "File with ports logged: $DATE.txt"
	for port in $port_num
		do
			sudo iptables -I INPUT -p tcp --dport $port -j ACCEPT
		echo $port "opened"
		done
	sudo iptables -P INPUT DROP 
  	echo "All other ${RED}INPUT${NOCOLOR} ports closed successfully!"
  	sudo iptables -L
  	exit 1	
fi