#!/bin/bash
set -e
source /pd_build/buildconfig
source /etc/environment
set -x

## Install Phusion Passenger.
if [[ "$PASSENGER_ENTERPRISE" ]]; then
	minimal_apt_get_install nginx-extras passenger-enterprise
else
	minimal_apt_get_install nginx-extras passenger
fi
cp /pd_build/config/30_presetup_nginx.sh /etc/my_init.d/
cp /pd_build/config/nginx.conf /etc/nginx/nginx.conf
mkdir -p /etc/nginx/main.d
cp /pd_build/config/nginx_main_d_default.conf /etc/nginx/main.d/default.conf
cp /pd_build/config/extend-http-nginx.conf /etc/nginx/conf.d/extend-http-nginx.conf

# Copy precompile scrip
cp /pd_build/config/precompile.sh /usr/local/bin/precompile.sh

# Copy syslog-ng config for nginx
cp /pd_build/config/syslog-ng-sources.conf /etc/syslog-ng/syslog-ng-sources.conf

## Install Nginx runit service.
mkdir /etc/service/nginx
cp /pd_build/runit/nginx /etc/service/nginx/run

mkdir /etc/service/nginx-log-forwarder
cp /pd_build/runit/nginx-log-forwarder /etc/service/nginx-log-forwarder/run
