#!/bin/bash


cd ~

sudo ufw default deny incoming
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 53
sudo ufw enable

sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install easy-rsa
echo $?
if echo $? eq 1 

mkdir -p ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
#chmod 700 ~/easy-rsa/
~/easy-rsa/easyrsa init-pki
echo $?
#cp -r /home/$USER/easyrsadeploy-/pki/ /home/alex/

cp ~/easy-rsa/vars.example ~/easy-rsa/vars
echo $?
#Because sed can't change only symbols in strings,i decided to add set_var in the end of file.
cat >> /home/$USER/easy-rsa/vars <<EOF
set_var EASYRSA_REQ_COUNTRY    "RU"
set_var EASYRSA_REQ_PROVINCE   "Russia"
set_var EASYRSA_REQ_CITY       "Moscow"
set_var EASYRSA_REQ_ORG        "Without company"
set_var EASYRSA_REQ_EMAIL      "Alekviper@gmail.com"
set_var EASYRSA_REQ_OU         "LLC"
EOF

~/easy-rsa/easyrsa build-ca
~/easy-rsa/easyrsa gen-req server nopass
~/easy-rsa/easyrsa sign-req server server
mkdir -p ~/clients/keys
~/easy-rsa/easyrsa gen-req client-1 nopass
sudo cp pki/private/client-1.key ./clients/keys/
~/easy-rsa/easyrsa sign-req client client-1
#sudo iptables -A INPUT -p tcp -m tcp -m multiport ! --dports 80,443,22 -j DROP
echo $?






