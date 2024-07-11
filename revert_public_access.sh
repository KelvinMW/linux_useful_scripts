#!/bin/bash
#chmod +x revert_public_access.sh
# Script to reverse the public access configuration

# Variables (Adjust as necessary)
INTERFACE="eth0"
PORT="80" # The port that was originally opened

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Revert static IP configuration
if grep -q "static" /etc/network/interfaces.d/$INTERFACE; then
  echo "Reverting static IP configuration..."
  sudo rm /etc/network/interfaces.d/$INTERFACE
  sudo systemctl restart networking
else
  echo "No static IP configuration found. Skipping..."
fi

# Remove the firewall rule
echo "Reverting firewall configuration..."
sudo ufw delete allow $PORT/tcp
sudo ufw reload

# Remove ddclient configuration
echo "Reverting Dynamic DNS configuration..."
sudo apt-get purge -y ddclient
sudo rm -f /etc/ddclient.conf

echo "Reversal of public access configuration is complete."

# End of script
