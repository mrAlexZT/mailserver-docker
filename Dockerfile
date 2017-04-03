FROM debian:jessie

MAINTAINER Jerome Zamaroczy

ENV DH_BITS=2048
ENV DAYS=3650

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN (apt-get update && \
     apt-get install -f -qq -y spamassassin procmail sasl2-bin clamav clamav-freshclam curl vim net-tools htop rsyslog \
     courier-authdaemon courier-authlib courier-authlib-userdb courier-imap courier-imap-ssl courier-ssl apt-utils postfix courier-base gamin && \
     apt-get clean)

COPY etc/courier/authdaemonrc /etc/courier/authdaemonrc
COPY etc/courier/imapd.cnf /etc/courier/imapd.cnf
COPY etc/courier/imapd /etc/courier/imapd
COPY etc/courier/imapd-ssl /etc/courier/imapd-ssl

COPY etc/postfix/dynamicmaps.cf /etc/postfix/dynamicmaps.cf
COPY etc/postfix/main.cf /etc/postfix/main.cf
COPY etc/postfix/master.cf /etc/postfix/master.cf
COPY etc/postfix/postfix-files /etc/postfix/postfix-files
COPY etc/postfix/sasl/smtpd.conf /etc/postfix/sasl/smtpd.conf
COPY etc/postfix/extfile.cnf /etc/postfix/extfile.cnf

COPY etc/init.d/gen-cert-smtps-sasl.sh /etc/init.d/gen-cert-smtps-sasl.sh 


COPY etc/procmailrc /etc/procmailrc
COPY etc/sasldb2 /var/spool/postfix/etc/sasldb2
COPY etc/mailname /etc/mailname

COPY etc/default/spamassassin /etc/default/spamassassin
COPY etc/default/saslauthd /etc/default/saslauthd

COPY etc/init.d/start.sh /etc/init.d/start.sh

RUN chmod +x /etc/init.d/gen-cert-smtps-sasl.sh
RUN chown postfix:sasl /var/spool/postfix/etc/sasldb2
RUN chmod 640 /var/spool/postfix/etc/sasldb2
RUN rm -rf /etc/sasldb2
RUN ln -s /var/spool/postfix/etc/sasldb2 /etc/sasldb2
RUN chmod +x /etc/init.d/start.sh
RUN useradd -ms /bin/bash jerome

VOLUME ["/home/jerome/Maildir"]
#USER jerome
WORKDIR /etc/courier

RUN rm -rf imapd.pem
RUN mkimapdcert
RUN sh /etc/init.d/gen-cert-smtps-sasl.sh

EXPOSE 587 465 25 993 143

CMD ["/bin/bash", "/etc/init.d/start.sh", "-d"]
