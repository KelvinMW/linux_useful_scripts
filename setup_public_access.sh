#!/bin/bash

# Variables
STATIC_IP="192.168.1.100"
SUBNET_MASK="255.255.255.0"
GATEWAY="192.168.1.1"
INTERFACE="eth0"
PORT="80" # Change this to the port your server listens on
DDNS_HOSTNAME="yourddns.example.com"
DDNS_USERNAME="yourddnsusername"
DDNS_PASSWORD="yourddnspassword"

# Configure Static IP
echo "Configuring static IP..."
cat <<EOL | sudo tee /etc/network/interfaces.d/$INTERFACE
auto $INTERFACE
iface $INTERFACE inet static
    address $STATIC_IP
    netmask $SUBNET_MASK
    gateway $GATEWAY
EOL
sudo systemctl restart networking

# Configure UFW to allow traffic on the specified port
echo "Configuring firewall..."
sudo ufw allow $PORT/tcp
sudo ufw reload

# Optionally configure DDNS (using ddclient)
echo "Configuring Dynamic DNS..."
sudo apt-get update
sudo apt-get install -y ddclient
sudo tee /etc/ddclient.conf > /dev/null <<EOL
daemon=300
syslog=yes
mail=root
mail-failure=root
pid=/var/run/ddclient.pid
ssl=yes
use=web, web=dynamicdns.park-your-domain.com/getip
protocol=dyndns2
server=members.dyndns.org
login=$DDNS_USERNAME
password='$DDNS_PASSWORD'
$DDNS_HOSTNAME
EOL

sudo systemctl restart ddclient

echo "Server is now publicly accessible via IP."

# End of script
