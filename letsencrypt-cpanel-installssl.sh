#!/bin/bash

cert=$(php5 -r "echo urlencode(file_get_contents(\"/etc/letsencrypt/live/$1/cert.pem\"));")
key=$(php5 -r "echo urlencode(file_get_contents(\"/etc/letsencrypt/live/$1/privkey.pem\"));")
ca=$(php5 -r "echo urlencode(file_get_contents(\"/etc/letsencrypt/live/bundle.txt\"));")

/usr/sbin/whmapi1 installssl domain=$1 crt=$cert key=$key cab=$ca
