#!/bin/bash
DOM=${DOMAINE}
CWD_PSTF=${CWD_PSTF}
DAYS=${DAYS}
DH_BITS=${DH_BITS}

# Prepare
rm -rf $CWD_PSTF/ssl
mkdir -p $CWD_PSTF/ssl

# Create a root private key
openssl genrsa -out $CWD_PSTF/ssl/cakey.pem $DH_BITS

# Create a self-signed root certificate
openssl req -x509 -new -nodes -key $CWD_PSTF/ssl/cakey.pem  \
    -days $DAYS -out $CWD_PSTF/ssl/cacert.pem \
    -subj "/C=FR/ST=FR/L=Paris/O=Courier SMTP Server/CN=smtp.$DOM"

# Create a private key for the final certificate
openssl genrsa -out $CWD_PSTF/ssl/smtpd.key 2048

# Create a certificate signing request
openssl req -new -key $CWD_PSTF/ssl/smtpd.key \
    -out $CWD_PSTF/ssl/smtpd.csr \
    -subj "/C=FR/ST=FR/L=Paris/O=Courier SMTP Server/CN=smtp.$DOM"

# Create a server certificate based on the root CA certificate
# and the root private key (and add extensions)
openssl x509 -req -in $CWD_PSTF/ssl/smtpd.csr \
    -CA $CWD_PSTF/ssl/cacert.pem  \
    -CAkey $CWD_PSTF/ssl/cakey.pem  -CAcreateserial \
    -out $CWD_PSTF/ssl/smtpd.crt \
    -days $DAYS -extensions v3_req -extfile $CWD_PSTF/extfile.cnf

