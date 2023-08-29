#!/bin/bash
mkdir /etc/xray
apt install socat -y

echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1│${NC}               • INPUT DOMAIN •                 ${NC} $COLOR1│$NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
read -rp "Input your domain: " -e pp
echo "$pp" > /etc/xray/domain 

echo "Please choose the 'Gen-Cert' menu to obtain a new domain certificate"
echo "Press any key to return to the main menu"
clear

domain=$(cat /etc/xray/domain)
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')

if [[ ! -z "$Cek" ]]; then
    sleep 1
    echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek" 
    systemctl stop $Cek
    sleep 2
    echo -e "[ ${GREEN}INFO${NC} ] Processing to stop $Cek" 
    sleep 1
fi

echo -e "[ ${GREEN}INFO${NC} ] Starting renew gen-ssl..."
sleep 2

sudo apt install curl socat -y
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m helpers@fxthur.my.id
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/xray/xray.key --fullchain-file /etc/xray/xray.crt

echo -e "[ ${GREEN}INFO${NC} ] Renew gen-ssl done..." 
sleep 2
echo -e "[ ${GREEN}INFO${NC} ] Starting service $Cek" 
sleep 2
echo -e "[ ${GREEN}INFO${NC} ] All finished..." 
sleep 0.5

sudo apt install nginx -y
cd
curl -fsSL https://get.docker.com | sh
wget -q -O /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/fxthur/marzban-nginx/main/xray.conf"
sleep 1

rm -r /etc/nginx/nginx.conf
wget -q -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/fxthur/marzban-nginx/main/nginx.conf"
service nginx restart
cd

sleep 2
wget -qO- https://github.com/fxthur/marzban-nginx/raw/main/multi-port.tar.gz | tar xz --xform 's/multi-port/marzban/' && cd marzban
sleep 2
rm -r xray_config.json
wget -q -O /root/marzban/xray_config.json "https://raw.githubusercontent.com/fxthur/marzban-nginx/main/xray_config.json"
docker compose up -d

 
echo "Installation has been completed"
echo "Please open the panel at http://yourdomain:8000/dashboard"