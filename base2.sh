DATE=`date +%m-%d-%y@%H)` 
DATE2=`date +%H:%M:%S)` 
RED='\033[0;31m'
NOCOLOR='\033[0m'
echo "Welcome\n"
echo "Input open ports by ${RED}FILE${NOCOLOR} or ${RED}INPUT${NOCOLOR}\n"
read file_input
echo "\n"
if [ "$file_input" = "FILE" ]; 
then
  echo "Please enter the files path ending in .txt\n"
  read file_path
  echo "\n"
  echo "$file_path Sucessfully Imported!"

else [ "$file_input" = "INPUT" ]; 
  read -p "Please enter ports number separated by space: " port_num
	#echo $port_num >> "$DATE.txt"
	echo "\n"
	echo "#newrun-""$DATE2" >> "$DATE.txt"
	for port in $port_num
		do
		echo $port >> "$DATE.txt"
		done
	echo "File with ports made: $DATE.txt"
fi


