<VirtualHost *:80>
    ServerName erp.elmischools.com
    ServerAdmin webmaster@elmischools.com

    ProxyPreserveHost On
    ProxyPass / http://localhost:8383/
    ProxyPassReverse / http://localhost:8383/

    ErrorLog ${APACHE_LOG_DIR}/erp.elmischools.com_error.log
    CustomLog ${APACHE_LOG_DIR}/erp.elmischools.com_access.log combined
</VirtualHost>

sudo a2ensite erp.elmischools.com.conf
sudo systemctl restart apache2

  sudo apt update
   sudo apt install certbot python3-certbot-apache

 sudo certbot --apache -d erp.elmischools.com

sudo certbot renew --dry-run

docker compose -f docker-compose.yml up -d --build
docker compose -f docker-compose.yml down
docker volume prune -f
