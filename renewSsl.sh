clear

domain=$(cat /etc/xray/domain)
portInUse=$(lsof -i:80 | awk 'NR==2 {print $1}')

if [[ ! -z "$portInUse" ]]; then
    sleep 1
    echo -e "[ \e[91mWARNING\e[0m ] Detected port 80 used by $portInUse" 
    systemctl stop $portInUse
    sleep 2
    echo -e "[ \e[92mINFO\e[0m ] Processing to stop $portInUse" 
    sleep 1
fi

echo -e "[ \e[92mINFO\e[0m ] Starting renew gen-ssl... " 
sleep 2

apt install curl socat -y
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
~/.acme.sh/acme.sh --register-account -m helpers@fxthur.my.id
~/.acme.sh/acme.sh --issue -d $domain --standalone
~/.acme.sh/acme.sh --installcert -d $domain --key-file /etc/xray/xray.key --fullchain-file /etc/xray/xray.crt

echo -e "[ \e[92mINFO\e[0m ] Renew gen-ssl done... " 
sleep 2
echo -e "[ \e[92mINFO\e[0m ] Starting service $portInUse " 
sleep 2
echo -e "[ \e[92mINFO\e[0m ] All finished... " 
sleep 0.5
echo ""
cd
