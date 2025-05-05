FROM rockylinux:8

ENV container docker

RUN dnf -y install epel-release && \
    dnf -y update && \
    dnf -y install wget net-tools nano curl git which tar openssl \
                   asterisk && \
    mkdir -p /etc/asterisk/keys && \
    openssl req -new -x509 -days 3650 -nodes \
    -subj "/C=BR/ST=SP/O=WebRTC Issabel/CN=pabx.w2itelecom.com.br" \
    -out /etc/asterisk/keys/asterisk.pem \
    -keyout /etc/asterisk/keys/asterisk.key

COPY config/sip_custom.conf /etc/asterisk/sip_custom.conf
COPY config/sip_general_custom.conf /etc/asterisk/sip_general_custom.conf
COPY config/http.conf /etc/asterisk/http.conf

RUN chown -R asterisk:asterisk /etc/asterisk || true

CMD ["/usr/sbin/asterisk", "-f"]

RUN mkdir -p /var/run/asterisk /var/log/asterisk /var/lib/asterisk /var/spool/asterisk /usr/lib64/asterisk/modules && \
    chown -R asterisk:asterisk /var/run/asterisk /var/log/asterisk /var/lib/asterisk /var/spool/asterisk /usr/lib64/asterisk/modules
