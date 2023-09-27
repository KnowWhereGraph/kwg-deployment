THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help start stop restart

BUILD_FILES := docker-compose.yml -f nginx/docker-compose.yml -f graphdb/docker-compose.yml -f elasticsearch/docker-compose.yml
BUILD_FILES_DEVELOP := docker-compose.yml -f nginx/docker-compose-dev.yml -f graphdb/docker-compose-dev.yml -f elasticsearch/docker-compose.yml

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
	docker-compose -f docker-compose.yml -f graphdb/docker-compose.develop.yml up -d $(c)
update-graphdb: # Replaces the existing GraphDB container with a new one
	docker-compose -f docker-compose.yml -f graphdb/docker-compose.develop.yml up -d $(c)
update-elasticsearch: # Replaces the existing ES container with a new one
	docker-compose -f docker-compose.yml -f elasticsearch/docker-compose.develop.yml up -d $(c)
