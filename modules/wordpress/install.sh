#!/bin/bash

# Met à jour le système
sudo yum update -y

# Installe Apache
sudo yum install -y httpd

# Installe PHP et les modules nécessaires
sudo yum install -y php-fpm php-cli php-pdo php-json php-mysqlnd php-{pear,cgi,common,curl,mbstring,gd,gettext,bcmath,xml,fpm,intl,zip,imap}

# Démarre Apache et PHP-FPM, et les configure pour démarrer au démarrage
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Ajoute l'utilisateur EC2 au groupe Apache pour assurer les permissions adéquates
sudo usermod -a -G apache ec2-user

# Change le propriétaire du répertoire web et ajuste les permissions
sudo chown -R ec2-user:apache /var/www/html
sudo chmod 2775 /var/www && sudo find /var/www -type d -exec sudo chmod 2775 {} \;
sudo find /var/www -type f -exec sudo chmod 0664 {} \;

# Crée une page PHP de test pour vérifier que PHP est bien interprété
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/phpinfo.php

# Télécharge et installe WordPress
sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

# Configure WordPress
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php

# Remplace les placeholders de la configuration par des variables
sudo sed -i "s/database_name_here/${db_name}/g" wp-config.php
sudo sed -i "s/username_here/${db_username}/g" wp-config.php
sudo sed -i "s/password_here/${db_password}/g" wp-config.php
sudo sed -i "s/localhost/${db_hostname}/g" wp-config.php

# Ajoute des configurations supplémentaires à wp-config.php
sudo cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Permet les fichiers .htaccess en modifiant la configuration Apache
sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

# Redémarre Apache et PHP-FPM pour appliquer les changements
sudo systemctl restart httpd
sudo systemctl restart php-fpm

# Message de succès
echo
echo "**************************************************************************************"
echo "******** WordPress installation script has been executed successfully ********"
echo "**************************************************************************************"
echo
