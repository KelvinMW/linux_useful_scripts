#!/bin/bash

# Script for configuring remote access

# Variables (Adjust as necessary)
INTERFACE="eth0"
PORT="80" # Change this to the port your server listens on

# Prompt for DDNS credentials
read -p "Enter your DDNS hostname: " DDNS_HOSTNAME
read -p "Enter your DDNS username: " DDNS_USERNAME
read -s -p "Enter your DDNS password: " DDNS_PASSWORD
echo ""

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Check for existing static IP configuration
if grep -q "static" /etc/network/interfaces.d/$INTERFACE; then
  echo "Interface $INTERFACE already configured with static IP. Skipping configuration."
else
  echo "Configuring static IP..."
  STATIC_IP=$(ip -o -4 addr show $INTERFACE | awk '{print $4}' | cut -d/ -f1)
  SUBNET_MASK=$(ifconfig $INTERFACE | grep -w "inet" | awk '{print $4}')
  GATEWAY=$(ip route | grep default | awk '{print $3}')
  
  cat <<EOL | sudo tee /etc/network/interfaces.d/$INTERFACE
auto $INTERFACE
iface $INTERFACE inet static
    address $STATIC_IP
    netmask $SUBNET_MASK
    gateway $GATEWAY
EOL
  sudo systemctl restart networking
fi

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

echo "**Important:**" 
echo "* This script configures a firewall rule. Ensure you understand the security implications."
echo "* Consider using a strong password or SSH key authentication for remote access."
echo "* Keep your services and Debian system updated with the latest security patches."

echo "Server may now be accessible via public IP or your DDNS hostname (if configured)."

# End of script
