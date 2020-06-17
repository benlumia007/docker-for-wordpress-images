.PHONY: all docker-setup docker-restore docker-backup

default: all

all: docker-setup docker-restore docker-backup

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-restore: provision/restore.sh
	/bin/bash provision/restore.sh

docker-backup: provision/backup.sh
	/bin/bash provision/backup.sh
