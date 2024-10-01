#!/bin/bash


cd ~

sudo ufw default deny incoming
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 53
sudo ufw enable

if [ $? -eq 0 ];
then

        echo "configuring firewall has been completed"
else
        echo "configuring firewall has fall"
        exit 1
fi

sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install easy-rsa
if [ $? -eq 0 ];
then
        echo "easy-rsa has been installed"
else
        echo "easy-rsa hasn't been installed"
        exit 1
fi



mkdir -p ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
#chmod 700 ~/easy-rsa/
~/easy-rsa/easyrsa init-pki
if [ $? -eq 0 ];
then
        echo "PKI has been initialization"
else
        echo "PKI  hasn't been initialization"
        exit 1
fi

#cp -r /home/$USER/easyrsadeploy-/pki/ /home/alex/

cp ~/easy-rsa/vars.example ~/easy-rsa/vars

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
if [ $? -eq 0 ];
then
        echo "root certificate  has been issued "
else
        echo "root certificate  hasn't been issued"
        exit 1
fi

~/easy-rsa/easyrsa gen-req server nopass
~/easy-rsa/easyrsa sign-req server server
if [ $? -eq 0 ];
then
        echo "server certificate  has been issued "
else
        echo "server certificate  hasn't been issued"
        exit 1
fi

mkdir -p ~/clients/keys
~/easy-rsa/easyrsa gen-req client-1 nopass
sudo cp pki/private/client-1.key ./clients/keys/
~/easy-rsa/easyrsa sign-req client client-1

if [ $? -eq 0 ];
then
        echo "client certificate  has been issued "
else
        echo "client certificate  hasn't been issued"
        exit 1
fi



