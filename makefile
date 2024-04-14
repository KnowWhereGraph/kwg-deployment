THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help start stop restart

BUILD_FILES := docker-compose.yaml -f nginx/docker-compose.yaml -f graphdb/docker-compose.prod.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.prod.yaml 
BUILD_FILES_DEVELOP := docker-compose.yaml -f nginx/docker-compose.yaml -f graphdb/docker-compose.local.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.local.yaml -f grafana/docker-compose.yaml

help:	## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

start:	## Brings the stack online, building images if needed
	docker-compose -f ${BUILD_FILES} up -d $(c)
stop:	## Brings the stack offline
	docker-compose -f ${BUILD_FILES} down $(c)
restart:	## Restarts the stack, does *not* do a rolling update
	docker-compose -f ${BUILD_FILES} stop $(c)
	docker-compose -f ${BUILD_FILES} up -d $(c)
start-dev:	## Brings the stack online, building images if needed
	docker-compose -f ${BUILD_FILES_DEVELOP} up -d $(c)
stop-dev:	## Brings the stack offline
	docker-compose -f ${BUILD_FILES_DEVELOP} down $(c)
restart-dev:
	docker-compose -f ${BUILD_FILES_DEVELOP} stop $(c)
	docker-compose -f ${BUILD_FILES_DEVELOP} up -d $(c)
update-graphdb-dev: # Replaces the existing GraphDB container with a new one
	docker-compose -f docker-compose.yaml -f graphdb/docker-compose.develop.yaml up -d $(c)
update-graphdb: # Replaces the existing GraphDB container with a new one
	docker-compose -f docker-compose.yaml -f graphdb/docker-compose.develop.yaml up -d $(c)
update-elasticsearch: # Replaces the existing ES container with a new one
	docker-compose -f docker-compose.yaml -f elasticsearch/docker-compose.develop.yaml up -d $(c)
update-nginx: # Replaces the existing nginx container with a new one
	docker-compose -f docker-compose.yaml -f nginx/docker-compose-dev.yaml up -d $(c)
