## Mailserver Postfix

## MIDLWARE version:

	postfix 2.11.3-1           2.11.3-1                  amd64        High-performance mail transport agent
        courier-authdaemon         0.66.1-1+b1               amd64        Courier authentication daemon
	courier-authlib            0.66.1-1+b1               amd64        Courier authentication library
	courier-authlib-userdb     0.66.1-1+b1               amd64        userdb support for the Courier authentication library
	courier-base               0.73.1-1.6                amd64        Courier mail server - base system
	courier-imap               4.15-1.6                  amd64        Courier mail server - IMAP server
	courier-imap-ssl           4.15-1.6                  amd64        Courier mail server - IMAP over SSL
	courier-ssl                0.73.1-1.6                amd64        Courier mail server - SSL/TLS Support
        spamassassin               3.4.0-6                   all          Perl-based spam filter using text analysis       
	libsasl2-modules-db:amd64  2.1.26.dfsg1-13+deb8u1    amd64        Cyrus SASL - pluggable authentication modules (DB)
        sa-compile                 3.4.0-6                   all          Tools for compiling SpamAssassin rules into C
        sasl2-bin                  2.1.26.dfsg1-13+deb8u1    amd64        Cyrus SASL - administration programs for SASL users database
	clamav                     0.99.2+dfsg-0+deb8u2      amd64        anti-virus utility for Unix - command-line interface
	clamav-base                0.99.2+dfsg-0+deb8u2      all          anti-virus utility for Unix - base package
	clamav-freshclam           0.99.2+dfsg-0+deb8u2      amd64        anti-virus utility for Unix - virus database update utility
	procmail                   3.22-24                   amd64        Versatile e-mail processor

## Installation and run first container
	
1. Create HOME directory user if restor Mairdir backup archive. It's optional feature
```bash
mkdir -p /home/user
cd /home/user/ && wget http://domaine.tld/Maildir-XX-XX.tar.gz
```

2.Build contener or pull image in registry
```bash
git clone https://github.com/nemoz28/mailserver-docker.git
cd mailserver-docker
docker build -t "mailserver-jzy:jessie"  --label mailserver-jzy .
```

3.Run container option argument example

- Create Generic container : default user jerome password localdomain zamaroczy.fr
```bash
docker run -t -i -p 587:587 -p 465:465 -p 25:25 -p 993:993 -p 143:143 mailserver-jzy /bin/bash
or not interactive
docker run -t -d -p 587:587 -p 465:465 -p 25:25 -p 993:993 -p 143:143 mailserver-jzy
```

- Create container set domaine user password in ARG ENV : PASSWORD=, USER=, DOMAINE=  
```bash
docker run -t -d  -p 587:587 -p 465:465 -p 25:25 -p 993:993 -p 143:143 -e PASSWORD=test -e USER=test -e DOMAINE=test.ts mailserver-jzy:jessie
```

- Create container and mount HOME directory USER with Maildir or Archive .tar.gz for Restor Backup
```bash
mkdir -p /backup
cd /backup && wget http://backup.domaine.tld/Maildir-XX-XX.tar.gz -> example
docker run -t -d -v /backup:/home/test -p 587:587 -p 465:465 -p 25:25 -p 993:993 -p 143:143 -e PASSWORD=test -e USER=test mailserver-jzy:jessie
```
