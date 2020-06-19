#!/usr/bin/env bash

config="/srv/.global/custom.yml"

# noroot
#
# noroot allows provision scripts to be run as the default user "www-data" rather than the root
# since provision scripts are run with root privileges.
noroot() {
    sudo -EH -u "www-data" "$@";
}


get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

for domain in `get_sites`; do

    if [[ ! -d "/etc/nginx/conf.d/${domain}.conf" ]]; then
      cp "/app/config/templates/nginx.conf" "/etc/nginx/conf.d/${domain}.conf"
      sed -i -e "s/{{DOMAIN}}/${domain}/g" "/etc/nginx/conf.d/${domain}.conf"
    fi


    get_site_provision() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.provision 2> /dev/null`
        echo ${value:-$@}
    }

    get_site_repo() {
        local value=`cat ${config} | shyaml get-value sites.${domain}.repo 2> /dev/null`
        echo ${value:-$@}
    }

    provision=`get_site_provision`
    repo=`get_site_repo`

    if [[ "True" == ${provision} ]]; then
        dir="/srv/www/${domain}"
        if [[ ! -d "${dir}/provision/.git" ]]; then
            noroot git clone ${repo} ${dir}/provision -q
        else
            cd ${dir}/provision
            noroot git pull -q
            cd /app
        fi

        if [[ -d ${dir} ]]; then
            if [[ -f ${dir}/provision/setup.sh ]]; then
               source ${dir}/provision/setup.sh
            fi
        fi
    fi
done
