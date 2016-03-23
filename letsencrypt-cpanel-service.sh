#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/

/root/letsencrypt/letsencrypt-auto --text certonly --renew-by-default --webroot --webroot-path /usr/local/apache/htdocs/ -d $HOSTNAME

/usr/local/sbin/letsencrypt-cpanel-installservice.sh