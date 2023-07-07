THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: build up start down destroy stop restart logs-nginx

BUILD_FILES := nginx/docker-compose.yml

build:
	docker-compose -f ${BUILD_FILES} build
up:
	docker-compose -f ${BUILD_FILES} up -d $(c)
down:
	docker-compose -f ${BUILD_FILES} down $(c)
destroy:
	docker-compose -f ${BUILD_FILES} down -v $(c)
restart:
	docker-compose -f ${BUILD_FILES} stop $(c)
	docker-compose -f ${BUILD_FILES} up -d $(c)
logs-nginx:
	docker-compose -f ${BUILD_FILES} logs --tail=100 -f nginx