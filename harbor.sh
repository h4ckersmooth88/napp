#!/bin/bash

cd /home/$MAINUSER/harbor_install
wget https://storage.googleapis.com/harbor-releases/release-1.6.0/harbor-online-installer-v1.6.0.tgz
tar xvf harbor-online-installer-v1.6.0.tgz
cd harbor
sed -i "s|hostname = reg.mydomain.com|hostname = $FQDN|g" harbor.cfg
sed -i "s|ui_url_protocol = http|ui_url_protocol = https|g" harbor.cfg
sed -i "s|ssl_cert = /data/cert/server.crt|ssl_cert = /root/cert/$FQDN.crt|g" harbor.cfg
sed -i "s|ssl_cert_key = /data/cert/server.key|ssl_cert_key = /root/cert/$FQDN.key|g" harbor.cfg

# Prepare Harbor
./prepare
# Install Harbor
./install.sh --with-notary --with-clair
