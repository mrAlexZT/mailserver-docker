# Mailserver Postfix

## Installation

1. Create /home/user
mkdir -p /home/USER/

2. Download Maildir archive data user backup
wget http://domaine.tld/Maildir-XX-XX.tar.gz

3.Build
docker build -t "postfix-jzy:jessie"  --label postfix-jzy .

4.Run container
docker run -t -i -v /home/user:/home/user -p 587:587 -p 465:465 -p 25:25 -p 993:993 -p 143:143 postfix-jzy:jessie /bin/bash

5.set password unix user
passwd user

6.set password sasl
saslpasswd2 -c -u smtp.domaine.tld -a smtpauth user
