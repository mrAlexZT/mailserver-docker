#!/bin/bash

DIRPATH=${DIRPATH}
USER=${USER}
HOME="/home/${USER}"
MAILDIR=${MAILDIR}
PASSWORD=${PASSWORD}
CWD_PSTF=${CWD_PSTF}
IP=$(echo `ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed   's/addr://'`)

useradd -d /home/$USER -ms /bin/bash  $USER
echo $USER:$PASSWORD | chpasswd -c MD5
echo $PASSWORD | saslpasswd2 -c -a smtpauth -u smtp.$DOMAINE $USER



# Control will enter here if $MAILDIR exists.
cd $HOME

if [ ! -d $MAILDIR ]; then
	if [ -f Maildir-*.tar.gz ]; then
  
  		tar -zxvf Maildir-*.tar.gz --strip-components=2

	else

  		maildirmake $MAILDIR
  		maildirmake -f Sent Maildir
  		maildirmake -f spam Maildir
  		maildirmake -f Trash Maildir

	fi
fi

chown -R $USER:$USER $HOME

#Set domaine in configuration postfix
sed -i -e "s/domaine.tld/$DOMAINE/g"  $CWD_PSTF/main.cf
sed -i -e "s/domaine.tld/$DOMAINE/g"  /etc/mailname
sed -i -e "s/domaine.tld/$DOMAINE/g"  $CWD_PSTF/extfile.cnf
sed -i -e "s/ip.local.priv/$IP/g"  $CWD_PSTF/extfile.cnf

#Generate Cert with local domaine.tld for IMAPs and SMTPs
$DIRPATH/gen-cert-smtps-sasl.sh


#Running environnement mailserver-docker + log output
$DIRPATH/rsyslog start
$DIRPATH/courier-authdaemon start
$DIRPATH/courier-imap start
$DIRPATH/courier-imap-ssl start
$DIRPATH/spamassassin start
$DIRPATH/saslauthd start
$DIRPATH/postfix start

tail -F /var/log/syslog

