#!/bin/bash
DOM=${DOMAINE}

CWD="/etc/postfix"

# Prepare
rm -rf $CWD/ssl
mkdir -p $CWD/ssl

# Create a root private key
openssl genrsa -out $CWD/ssl/cakey.pem 2048

# Create a self-signed root certificate
openssl req -x509 -new -nodes -key $CWD/ssl/cakey.pem  \
    -days 3650 -out $CWD/ssl/cacert.pem \
    -subj "/C=FR/ST=FR/L=Paris/O=Courier SMTP Server/CN=smtp.$DOM"

# Create a private key for the final certificate
openssl genrsa -out $CWD/ssl/smtpd.key 2048

# Create a certificate signing request
openssl req -new -key $CWD/ssl/smtpd.key \
    -out $CWD/ssl/smtpd.csr \
    -subj "/C=FR/ST=FR/L=Paris/O=Courier SMTP Server/CN=smtp.$DOM"

# Create a server certificate based on the root CA certificate
# and the root private key (and add extensions)
openssl x509 -req -in $CWD/ssl/smtpd.csr \
    -CA $CWD/ssl/cacert.pem  \
    -CAkey $CWD/ssl/cakey.pem  -CAcreateserial \
    -out $CWD/ssl/smtpd.crt \
    -days 3650 -extensions v3_req -extfile $CWD/extfile.cnf

