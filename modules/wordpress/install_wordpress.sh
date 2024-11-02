#!/bin/bash

sudo yum update -y
sudo yum install -y httpd

sudo yum install -y php-fpm php-cli php-pdo php-json php-mysqlnd

sudo systemctl start httpd
sudo systemctl start php-fpm

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

cd /var/www/html
sudo cp wp-config-sample.php wp-config.php

sudo sed -i "s/database_name_here/${db_name}/g" wp-config.php
sudo sed -i "s/username_here/${db_username}/g" wp-config.php
sudo sed -i "s/password_here/${db_password}/g" wp-config.php
sudo sed -i "s/localhost/${db_hostname}/g" wp-config.php
sudo cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

sudo systemctl enable httpd
sudo systemctl enable php-fpm
sudo systemctl restart httpd
sudo systemctl restart php-fpm