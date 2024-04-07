#!/bin/bash

#set -e

if [[ "$EUID" -ne 0 ]]; then
  echo "Error: Please run as root with sudo."
  exit
fi

if [ -f checkpoint.txt ]; then
    if [ -s "$file" ]; then
        checkpoint=$(< "$file")
    else
        checkpoint="start"
    fi
else
    checkpoint="start"
fi


export DEBIAN_FRONTEND=noninteractive

install_apach() {
    apt install apache2 -y --no-install-recommends --no-install-suggests
}

update () {
    apt-get update 
    apt-get -y --no-install-recommends --no-install-suggests upgrade
    apt-get -y --no-install-recommends --no-install-suggests autoremove
}

install_mysql() {
    apt install mysql-server -y --no-install-recommends --no-install-suggests
}

install_php() {
    apt install -y --no-install-recommends --no-install-suggests php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
}

install_wp() {
    wget https://wordpress.org/latest.tar.gz
    if [  -d "/var/www/wordpress" ]; then
        rm -r /var/www/wordpress
    fi
    tar -zxvf latest.tar.gz -C /var/www/
    
}

install_nx() {
    apt install nginx -y --no-install-recommends --no-install-suggests 
}

install_dr() {
    wget https://www.drupal.org/download-latest/tar.gz -O drupal.tar.gz
    tar -zxvf drupal.tar.gz
    if [  -d "/var/www/drupal" ]; then
        rm -r /var/www/drupal
    fi
    mkdir -p /var/www/drupal
    mv -f drupal*/* /var/www/drupal
    cp /var/www/drupal/sites/default/default.settings.php /var/www/drupal/sites/default/settings.php 
    mkdir /var/www/drupal/sites/default/files
    chmod a+w /var/www/drupal/sites/default/files
    chmod a+w /var/www/drupal/sites/default
}

apache_init() {
    curl -o /etc/apache2/sites-enabled/dr-wp.conf  https://raw.githubusercontent.com/am11001/conf_files/files/dr-wp.conf
    systemctl enable apache2
    systemctl restart apache2
}

db_init() {
    wget https://raw.githubusercontent.com/am11001/conf_files/files/init.sql
    mysql -u root  < init.sql

}

nginx_init() {
    curl -o /etc/nginx/conf.d/nginx.conf https://raw.githubusercontent.com/am11001/conf_files/files/nginx.conf
    systemctl enable nginx
    systemctl restart nginx
}



installation() {
    install_apach
    install_mysql
    install_php
    install_wp
    install_nx
    install_dr
}

cleaning() {
    rm -rf /var/www/html
    rm -f /etc/apache2/sites-enabled/*
    rm -f /etc/apache2/sites-available/*
    rm -f /etc/nginx/conf.d/*
    echo "" > /etc/apache2/ports.conf 
    
}

init() {
    apache_init
    db_init
    nginx_init
}

conf() {
    systemctl restart apache2
    sleep 2
    systemctl restart nginx
    sleep 2
    sudo chown -R www-data:www-data /var/www/
    sudo chmod -R 777 /var/www/

}

notify(){
    recipient="user@example.com"
    subject=$1
    message=$2
    
    curl -X POST -H "Content-Type: application/json" -d "{"user":$recipient ,"subject":$subject, "message":$message}" https://webhook.site/e64faa52-8391-4a4d-b399-f414a7820cc4
}

test=true


while $test; do
    case $checkpoint in
        "start")
            update || {
                echo "start" > checkpoint.txt
                exit 1
            }
            checkpoint="install"
            ;;
        "install")
            installation || {
                echo "install" > checkpoint.txt
                exit 1
            }
            checkpoint="cleaning"
            ;;
        "cleaning")
            cleaning || {
                echo "cleaning" > checkpoint.txt
                exit 1
            }
            checkpoint="init"
            ;;
        "init")
            init || {
                echo "init" > checkpoint.txt
                exit 1
            }
            checkpoint="conf"
            ;;
        "conf")
            init || {
                echo "conf" > checkpoint.txt
                exit 1
            }
            test=false
            echo "" > checkpoint.txt
            ;;
        *)
            notify "error" "Unknown checkpoint: $checkpoint"
            echo "" > checkpoint.txt
            exit 1
            ;;
    esac
done


sudo chown -R www-data:www-data /var/www/
sudo chmod -R 777 /var/www/



echo "_________##############################_________________"
notify "done" "Installation completed successfully."
echo "_________##############################_________________"





