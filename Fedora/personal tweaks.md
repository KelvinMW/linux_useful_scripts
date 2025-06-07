Enable Locacte Pointer
gsettings set org.gnome.desktop.interface locate-pointer true

Install OpenBoard

PHP
dnf install mysql-server php-gd php-mysql php-zip php-curl php-gettext php-pdo

# Make your user the owner, nginx the group and own /www/ files
sudo chown -R $USER:nginx /var/www/

# Set directory permissions (755 + group write)
sudo find /var/www/ -type d -exec chmod 775 {} \;
