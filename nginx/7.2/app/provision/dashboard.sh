#!/usr/bin/env bash

repo="https://github.com/benlumia007/wp-4-docker-dashboard.git"
dir="/srv/www/dashboard/public_html"

# noroot
#
# noroot allows provision scripts to be run as the default user "vagrant" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "www-data" "$@";
}

if [[ ! -d "/etc/nginx/conf.d/dashboard.conf" ]]; then
  cp "/app/config/templates/nginx.conf" "/etc/nginx/conf.d/dashboard.conf"
  sed -i -e "s/{{DOMAIN}}/dashboard/g" "/etc/nginx/conf.d/dashboard.conf"
fi

if [[ false != "${repo}" ]]; then
    if [[ ! -d ${dir}/.git ]]; then
        noroot git clone ${repo} ${dir} -q
    else
        cd ${dir}
        noroot git pull -q
        cd /app
    fi
fi
