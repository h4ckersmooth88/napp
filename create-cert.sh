# Create Self-Signed OpenSSL Certs
mkdir -p /home/$MAINUSER/harbor_install
mkdir -p /home/$MAINUSER/harbor_install/openssl
cd /home/$MAINUSER/harbor_install/openssl
FQDN="$(hostname -f)"
echo subjectAltName = IP:"$(hostname --ip-address)" > extfile.cnf
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 3650 -out ca.crt -subj "/C=US/ST=CA/L=San Francisco/O=VMware/OU=IT Department/CN=${FQDN}"
openssl req -newkey rsa:4096 -nodes -sha256 -keyout ${FQDN}.key -out ${FQDN}.csr -subj "/C=US/ST=CA/L=San Francisco/O=VMware/OU=IT Department/CN=${FQDN}"
openssl x509 -req -days 3650 -in ${FQDN}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extfile extfile.cnf -out ${FQDN}.crt

# Copy certs to root for Harbor Inatallation
mkdir -p /root/cert/
cp ${FQDN}.crt /root/cert/
cp ${FQDN}.key /root/cert/

# Copy certs to Docker to get around X509 unauthorized cert error
mkdir -p /etc/docker/certs.d/${FQDN}/
cp ${FQDN}.crt /etc/docker/certs.d/${FQDN}/
cp ${FQDN}.key /etc/docker/certs.d/${FQDN}/
cp ca.crt /etc/docker/certs.d/${FQDN}/
cp ca.key /etc/docker/certs.d/${FQDN}/
cp /etc/docker/certs.d/${FQDN}/${FQDN}.crt /etc/docker/certs.d/${FQDN}/${FQDN}.cert
cp /etc/docker/certs.d/${FQDN}/ca.crt /etc/docker/certs.d/${FQDN}/ca.cert
