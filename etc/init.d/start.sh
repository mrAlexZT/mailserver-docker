#!/bin/bash

tar -zxvf Maildir-*.tar.gz --strip-components=3
rm -rf Maildir-*.tar.gz
chown jerome:jerome ../Maildir

#IP="$(ifconfig eth0 | sed -n '/inet adr/s/.*adr.\([^ ]*\) .*/\1/p')"
#echo "$IP    zamaroczy.fr smtp.zamaroczy.fr mail.zamaroczy.fr imaps.zamaroczy.fr" >> /etc/hosts

/etc/init.d/rsyslog start
/etc/init.d/courier-authdaemon start
/etc/init.d/courier-imap start
/etc/init.d/courier-imap-ssl start
/etc/init.d/spamassassin start
/etc/init.d/saslauthd start
/etc/init.d/postfix start

tail -f /var/log/mail.log
