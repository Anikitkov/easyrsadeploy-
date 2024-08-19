#!/bin/bash

sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install easy-rsa
echo $?

mkdir -p ~/easy-rsa
ln -s /usr/share/easy-rsa/* ~/easy-rsa/
chmod 700 ~/easy-rsa/
~/easy-rsa/easyrsa init-pki
echo $?
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
echo $?





