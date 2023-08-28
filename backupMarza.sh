#!/bin/bash

# Update dan upgrade sistem
apt update && apt upgrade -y

# Buat direktori untuk penyimpanan konfigurasi XRay
mkdir -p /etc/xray

# Instal socat sebagai dependensi
apt install socat -y

# Input domain dari pengguna
echo -e "┌─────────────────────────────────────────────────┐"
echo -e "│               • INPUT DOMAIN •                 │"
echo -e "└─────────────────────────────────────────────────┘"
read -rp "Input your domain: " -e domain
echo "$domain" > /etc/xray/domain 

# Informasi dan instruksi mengenai pemasangan sertifikat
echo "Please choose the 'Gen-Cert' menu to obtain a new domain certificate"
read -rsp "Press any key to return to the main menu..."

# Hentikan layanan yang menggunakan port 80
portInUse=$(lsof -i:80 | awk 'NR==2 {print $1}')
if [[ ! -z "$portInUse" ]]; then
    systemctl stop $portInUse
    echo "[ WARNING ] Detected port 80 used by $portInUse, stopping the service..."
    sleep 2
fi

# Pemasangan sertifikat menggunakan acme.sh
echo "[ INFO ] Starting certificate renewal..."
sleep 2
yum install curl socat -y
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m helpers@fxthur.my.id
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/xray/xray.key --fullchain-file /etc/xray/xray.crt
echo "[ INFO ] Certificate renewal completed."

# Restart layanan yang menggunakan port 80 (nginx)
echo "[ INFO ] Starting service..."
sleep 2
sudo apt install nginx -y

# Backup dan pindahkan file konfigurasi Marzban
mkdir -p /var/lib/marzban/backup
mv /var/lib/marzban/db.sqlite3 /var/lib/marzban/backup/db.sqlite3
mv /var/lib/marzban/xray_config.json /var/lib/marzban/backup/xray_config.json
mv db.sqlite3 /var/lib/marzban/db.sqlite3
mv xray_config.json /var/lib/marzban/xray_config.json

# Pindahkan file konfigurasi Nginx
rm /etc/nginx/conf.d/xray.conf
mv xray.conf /etc/nginx/conf.d/xray.conf
service nginx restart

echo "[ INFO ] Configuration files and services are updated."
echo "Please change the username and password as needed."
