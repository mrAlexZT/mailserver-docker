#!/bin/bash

DIRPATH=${DIRPATH}
HOME=${HOME}
USER=${USER}
MAILDIR=${MAILDIR}

# Control will enter here if $MAILDIR exists.
cd $HOME
untar=`tar -zxvf Maildir-*.tar.gz --strip-components=2`


if [ -f "$untar" ]; then


  rm -rf Maildir-*.tar.gz

else

 maildirmake

fi

chown -R $USER:$USER $HOME

$DIRPATH/rsyslog start
$DIRPATH/courier-authdaemon start
$DIRPATH/courier-imap start
$DIRPATH/courier-imap-ssl start
$DIRPATH/spamassassin start
$DIRPATH/saslauthd start
$DIRPATH/postfix start

tail -f /var/log/mail.log
