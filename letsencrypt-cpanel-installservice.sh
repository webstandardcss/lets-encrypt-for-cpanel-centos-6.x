#!/bin/bash

cert=$(php -r "echo urlencode(file_get_contents(\"/etc/letsencrypt/live/$HOSTNAME/cert.pem\"));")
key=$(php -r "echo urlencode(file_get_contents(\"/etc/letsencrypt/live/$HOSTNAME/privkey.pem\"));")

/usr/sbin/whmapi1 install_service_ssl_certificate service=ftp crt=$cert key=$key
/scripts/restartsrv_ftpd
/scripts/restartsrv_ftpserver
/usr/sbin/whmapi1 install_service_ssl_certificate service=exim crt=$cert key=$key
/scripts/restartsrv_exim
/usr/sbin/whmapi1 install_service_ssl_certificate service=dovecot crt=$cert key=$key
/scripts/restartsrv_dovecot
/usr/sbin/whmapi1 install_service_ssl_certificate service=cpanel crt=$cert key=$key
/scripts/restartsrv_cpsrvd