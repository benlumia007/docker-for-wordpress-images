#!/usr/bin/env bash

# custom.yml
#
# This is the main custom.yml that allows the container to automate scripts using yaml and shyaml
# together so that you don't have to do anything.
config="/srv/.global/custom.yml"

# noroot
#
# noroot allows provision scripts to be run as the default user "www-data" rather than the root
# since provision scripts are run with root privileges. noroot only allows to modify or create
# certain areas when needed.
noroot() {
    sudo -EH -u "www-data" "$@";
}

if [[ ! -f "${config}" ]]; then
  noroot cp "/app/config/templates/default.yml" "/srv/.global/custom.yml"
fi
