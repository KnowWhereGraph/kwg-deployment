THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help start stop restart

BUILD_FILES_PROD := docker-compose.yaml -f nginx/docker-compose.prod.yaml -f graphdb/docker-compose.prod.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.prod.yaml 
BUILD_FILES_LOCAL := docker-compose.yaml -f nginx/docker-compose.local.yaml -f graphdb/docker-compose.local.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.local.yaml -f grafana/docker-compose.yaml
BUILD_FILES_STAGE := docker-compose.yaml -f nginx/docker-compose.stage.yaml -f graphdb/docker-compose.stage.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.local.yaml -f grafana/docker-compose.yaml

help:	## Show this help.
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

start-prod:	## Brings the stack online, for https://stko-kwg.geog.ucsb.edu building images if needed
	docker-compose -f ${BUILD_FILES_PROD} up -d $(c)
stop-prod:	## Brings the stack offline
	docker-compose -f ${BUILD_FILES_PROD} down $(c)
start-local:	## Brings the stack online, for running on a local development machine
	docker-compose -f ${BUILD_FILES_LOCAL} up -d $(c)
stop-local:	## Brings the stack offline
	docker-compose -f ${BUILD_FILES_LOCAL} down $(c)
start-stage:	## Brings the stack online for staging.knowwheregraph.org, building images if needed
	docker-compose -f ${BUILD_FILES_STAGE} up -d $(c)
stop-stage:	## Brings the stack offline for staging.knowwheregraph.org
	docker-compose -f ${BUILD_FILES_STAGE} down $(c)
start-local-preload: # Ingests data into GraphDB for the first time. Only launches GraphDB. For local development
	docker-compose -f docker-compose.yaml -f graphdb/docker-compose.local.preload.yaml up -d $(c)
start-stage-preload: # Ingests data into GraphDB for the first time. Only launches GraphDB. For stage deployment
	docker-compose -f docker-compose.yaml -f graphdb/docker-compose.stage.preload.yaml up -d $(c)
start-prod-preload: # Ingests data into GraphDB for the first time. Only launches GraphDB. For prod deployment
	docker-compose -f docker-compose.yaml -f graphdb/docker-compose.prod.preload.yaml up -d $(c)