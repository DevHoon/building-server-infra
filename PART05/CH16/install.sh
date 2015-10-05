#!/bin/bash
#
# Install nginx
#
# @author harukasan <harukasan@pixiv.com>

set -e

NGINX_VERSION=1.2.6
PCRE_VERSION=8.32

## for debian/ubuntu:
# sudo aptitude install zlib1g-dev
# sudo aptitude install libssl-dev

wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.tar.gz

tar xvf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}

./configure \
    --prefix=/usr/local/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --with-pcre=../pcre-${PCRE_VERSION}

make
sudo make install
