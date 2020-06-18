.PHONY: all docker-setup docker-restore docker-backup

default: all

all: docker-setup docker-restore docker-backup

docker-setup: provision/setup.sh
	/bin/bash provision/setup.sh

docker-restore: provision/db_restore.sh
	/bin/bash provision/db_restore.sh

docker-backup: provision/db_backup.sh
	/bin/bash provision/db_backup.sh
