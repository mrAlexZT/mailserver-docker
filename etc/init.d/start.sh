#!/bin/bash

DIRPATH=${DIRPATH}
USER=${USER}
MAILDIR=${MAILDIR}

# Control will enter here if $MAILDIR exists.
cd /home/$USER
untar=`tar -zxvf Maildir-*.tar.gz --strip-components=3`

if [ -d "$untar" ]; then


  rm -rf Maildir-*.tar.gz
fi

else

 maildirmake -f $MAILDIR

fi

chown $USER:$USER $MAILDIR


$DIRPATH/rsyslog start
$DIRPATH/courier-authdaemon start
$DIRPATH/courier-imap start
$DIRPATH/courier-imap-ssl start
$DIRPATH/spamassassin start
$DIRPATH/saslauthd start
$DIRPATH/postfix start

tail -f /var/log/mail.log
