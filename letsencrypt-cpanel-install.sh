#!/bin/bash

export OS_RELEASE=$(rpm -qa '(oraclelinux|sl|redhat|centos)-release(|-server)')
export OS_VERSION=$(echo ${OS_RELEASE}|cut -d- -f3)
export OS_ARCH=$(echo ${OS_RELEASE}|grep -o '..$')
echo "OS Release is: ${OS_RELEASE}"
echo "Your OS version is: ${OS_VERSION}"
echo "You have a ${OS_ARCH} bit processor."

if [ "${OS_VERSION}" -ge "7" ]
then
  yum -y install git
  cd /root
  git clone https://github.com/letsencrypt/letsencrypt
  cd /root/letsencrypt
  ./letsencrypt-auto --verbose
  echo "** Done installing Git and Lets Encrypt"
fi

if [ "${OS_VERSION}" -le "6" ]
then
  rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
  rpm -ivh https://rhel6.iuscommunity.org/ius-release.rpm
  yum -y install git python27 python27-devel python27-pip python27-setuptools python27-virtualenv --enablerepo=ius
  cd /root
  git clone https://github.com/letsencrypt/letsencrypt
  cd /root/letsencrypt
  sed -i "s|--python python2|--python python2.7|" letsencrypt-auto
  ./letsencrypt-auto --verbose
  echo "** Done installing Python 2.7 and Lets Encrypt"
fi

touch /usr/local/sbin/userdomains
chmod 755 /usr/local/sbin/userdomains
cat << "EOF" > /usr/local/sbin/userdomains
#!/bin/bash

grep -E ": $1\$" /etc/userdomains | awk '{print$1}' | sed 's/:$//'
EOF

mkdir -p /etc/letsencrypt/live/

cat << "EOFFF" > /etc/letsencrypt/live/bundle.txt
-----BEGIN CERTIFICATE-----
MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/
MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMT
DkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0Nlow
SjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMT
GkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EF
q6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8
SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0
Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWA
a6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj
/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0T
AQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIG
CCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNv
bTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9k
c3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAw
VAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcC
ARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAz
MDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwu
Y3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsF
AAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJo
uM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/
wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwu
X4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlG
PfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6
KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg==
-----END CERTIFICATE-----
EOFFF

cp /etc/letsencrypt/live/bundle.txt /etc/letsencrypt/live/bundle.crt

echo '** Done installing certificate'
echo '**** Usage below' 
echo '** See https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/ for details.'
echo '****'