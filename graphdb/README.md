# kwg-graphdb

KnowWhereGraph's GraphDB deployment configuration

## Overview

KnowWhereGraph uses a single node GraphDB Enterprise instance to store and process data requests.

## Data Persistence

Data is persisted on the host machine, _not_ the container. This is achieved by a volume mount between the host and GraphDB's repository data directory which is set in the docker-compose file. Graph DB stores its repository, configuration, and logging data under `/opt/graphdb/home`. This path can be mounted to the local system, persisting the data. When a new container is launched, it will reference the persisted data and load it.

## Deploying

To start GraphDB standalone, run

`docker-compose up`

A docker-compose file for local development is provided with relaxed system requirements.

## Logging

GraphDB has several rolling log files that are in the GraphDB home directory, making it difficult to use `docker logs <container_name>`. Instead, the logs are mounted to the local volume through the docker-compose file.
