#!/bin/bash


pub_ip=$(wget -qO- https://ipecho.net/plain ; echo)

#root check

if ! [ $(id -u) = 0 ]; then
   echo -e "${RED}Plese run the script with root privilages!${ENDCOLOR}"
   exit 1
fi

spinner()
{
    #Loading spinner
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
pre_req()
{
        #installing pre-requirements and adding port rules to ubuntu firewall
		
	apt update -y && apt upgrade -y

        apt-get install -y dropbear && apt-get install -y stunnel4 && apt-get install -y squid && apt-get install -y cmake && apt-get install -y python3 && apt-get install -y screenfetch && apt-get install -y openssl
        ufw allow 443/tcp
	ufw allow 444/tcp
        ufw allow 22/tcp
        ufw allow 80/tcp
        ufw allow 110/tcp
        ufw allow 8080/tcp
        ufw allow 7300/tcp
        ufw allow 7300/udp
}
mid_conf()
{


#Configuring stunnel

mkdir /etc/stunnel
cat << EOF > /etc/stunnel/stunnel.conf
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[stunnel]
connect = 0.0.0.0:22
accept = 443
sslVersion = all
EOF

#Genarating a self signed certificate for stunnel

openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" \
    -out stunnel.pem  -keyout stunnel.pem

cp stunnel.pem /etc/stunnel/stunnel.pem
chmod 644 /etc/stunnel/stunnel.pem
}
fun_service_start()
{
#enabling and starting all services

useradd -m udpgw

service stunnel4 restart
service ssh restart
/etc/init.d/stunnel4 restart

}
