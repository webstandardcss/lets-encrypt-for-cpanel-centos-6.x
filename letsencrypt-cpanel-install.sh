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
MIIEqDCCA5CgAwIBAgIRAJgT9HUT5XULQ+dDHpceRL0wDQYJKoZIhvcNAQELBQAw
PzEkMCIGA1UEChMbRGlnaXRhbCBTaWduYXR1cmUgVHJ1c3QgQ28uMRcwFQYDVQQD
Ew5EU1QgUm9vdCBDQSBYMzAeFw0xNTEwMTkyMjMzMzZaFw0yMDEwMTkyMjMzMzZa
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAJzTDPBa5S5Ht3JdN4OzaGMw6tc1Jhkl4b2+NfFwki+3uEtB
BaupnjUIWOyxKsRohwuj43Xk5vOnYnG6eYFgH9eRmp/z0HhncchpDpWRz/7mmelg
PEjMfspNdxIknUcbWuu57B43ABycrHunBerOSuu9QeU2mLnL/W08lmjfIypCkAyG
dGfIf6WauFJhFBM/ZemCh8vb+g5W9oaJ84U/l4avsNwa72sNlRZ9xCugZbKZBDZ1
gGusSvMbkEl4L6KWTyogJSkExnTA0DHNjzE4lRa6qDO4Q/GxH8Mwf6J5MRM9LTb4
4/zyM2q5OTHFr8SNDR1kFjOq+oQpttQLwNh9w5MCAwEAAaOCAZIwggGOMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMH8GCCsGAQUFBwEBBHMwcTAy
BggrBgEFBQcwAYYmaHR0cDovL2lzcmcudHJ1c3RpZC5vY3NwLmlkZW50cnVzdC5j
b20wOwYIKwYBBQUHMAKGL2h0dHA6Ly9hcHBzLmlkZW50cnVzdC5jb20vcm9vdHMv
ZHN0cm9vdGNheDMucDdjMB8GA1UdIwQYMBaAFMSnsaR7LHH62+FLkHX/xBVghYkQ
MFQGA1UdIARNMEswCAYGZ4EMAQIBMD8GCysGAQQBgt8TAQEBMDAwLgYIKwYBBQUH
AgEWImh0dHA6Ly9jcHMucm9vdC14MS5sZXRzZW5jcnlwdC5vcmcwPAYDVR0fBDUw
MzAxoC+gLYYraHR0cDovL2NybC5pZGVudHJ1c3QuY29tL0RTVFJPT1RDQVgzQ1JM
LmNybDATBgNVHR4EDDAKoQgwBoIELm1pbDAdBgNVHQ4EFgQUqEpqYwR93brm0Tm3
pkVl7/Oo7KEwDQYJKoZIhvcNAQELBQADggEBANHIIkus7+MJiZZQsY14cCoBG1hd
v0J20/FyWo5ppnfjL78S2k4s2GLRJ7iD9ZDKErndvbNFGcsW+9kKK/TnY21hp4Dd
ITv8S9ZYQ7oaoqs7HwhEMY9sibED4aXw09xrJZTC9zK1uIfW6t5dHQjuOWv+HHoW
ZnupyxpsEUlEaFb+/SCI4KCSBdAsYxAcsHYI5xxEI4LutHp6s3OT2FuO90WfdsIk
6q78OMSdn875bNjdBYAqxUp2/LEIHfDBkLoQz0hFJmwAbYahqKaLn73PAAm1X2kj
f1w8DdnkabOLGeOVcj9LQ+s67vBykx4anTjURkbqZslUEUsn2k5xeua2zUk=
-----END CERTIFICATE-----
EOFFF

cp /etc/letsencrypt/live/bundle.txt /etc/letsencrypt/live/bundle.crt

echo '** Done installing certificate'
echo '**** Usage below' 
echo '** See https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/ for details.'
echo '****'