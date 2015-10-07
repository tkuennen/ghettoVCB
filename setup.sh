#/bin/ash!
#       _          _   _     __     ______ ____  
#  __ _| |__   ___| |_| |_ __\ \   / / ___| __ ) 
# / _` | '_ \ / _ \ __| __/ _ \ \ / / |   |  _ \ 
#| (_| | | | |  __/ |_| || (_) \ V /| |___| |_) |
# \__, |_| |_|\___|\__|\__\___/ \_/  \____|____/ 
# |___/ 

script="setup.sh"
version="0.1"
run_dir=$(echo "$PWD")
user=$(whoami)  

cd /vmfs/volumes/datastore1/
wget https://github.com/tkuennen/ghettoVCB.git

esxcli software vib install -v ./vghetto-ghettoVCB.vib -f

cp ./ghettoVCP/smtpout.xml /etc/vmware/firewall/smtpout.xml

chmod 444 /etc/vmware/firewall/smtpout.xml

esxcli network firewall refresh


#                                      
