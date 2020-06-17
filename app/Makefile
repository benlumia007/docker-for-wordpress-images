.PHONY: all docker-dashboard docker-sites docker-resources

default: all

all: docker-dashboard docker-sites docker-resources

docker-dashboard: provision/dashboard.sh
	/bin/bash provision/dashboard.sh

docker-sites: provision/sites.sh
	/bin/bash provision/sites.sh

docker-resources: provision/resources.sh
	/bin/bash provision/resources.sh
