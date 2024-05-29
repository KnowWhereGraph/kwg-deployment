# kwg-graphdb

KnowWhereGraph's GraphDB deployment configuration

## Overview

KnowWhereGraph uses a single node GraphDB Enterprise instance to store and process data requests.

There are *six* docker-compose files here. The two main flavors are

1. Preloading: These compose files are used to the first upload of data. There are three (local/stage/prod)
2. Running: These compose files are used when running GraphDB to serve content. There are three (local/stage/prod)

## Data Persistence

Data is persisted on the host machine, _not_ the container. This is achieved by a volume mount between the host and GraphDB's repository data directory which is set in the docker-compose file. Graph DB stores its repository, configuration, and logging data under `/opt/graphdb/home`. This path can be mounted to the local system, persisting the data. When a new container is launched, it will reference the persisted data and load it.

## Deploying

GraphDB deployments should be managed by the repositorie's root Makefile. Run `make help` for a description of commands and follow the documentation below to learn more about loading data & deploying.

### Initial Data Load

GraphDB's initial database is constructed using the `importrdf` tool from Ontotext. This runs with GraphDB offline and offers much faster data loading than other options. In this process, GraphDB creates a new repository and inserts data into it. To account for this, separate docker-compose files are needed to manage the offline instances.

In order to properly load data,

1. The repository configuration *must* be supplied in `graphdb-data/home/data/repositories/<your-repo-name-here>/config.ttl`
2. The data being imported *must* be placed in `graphdb-data/import-data`
3. If the repository name is anything other than `KWG`, modify the Makefile to account for this change
4. `make start-<env>-preload` should be called from the project root, where env={local/stage/prod}

Loading KnowWhereGraph's data can take days. Once this is complete,

1. The docker container will exit
2. Confirm the success by checking the logs in the `logs` folder here, or by getting the docker logs
3. The Data Serving deployment can be initiated (see below)

#### Debugging

In the case that something goes wrong, the docker container will most likely exit.

1. Get the logs of the stopped container with `docker ps --all`
2. `docker logs <container_id>`
3. Also check the mounted logs folder in `graphdb-data/logs`

### Data Serving (normal deployment)

When data doesn't need to be loaded and GraphDB is meant to be started as a service that functions as a normal database,

1. Use `make start-<env>` where env={local/stage.prod} to start the service with the rest of the stack

If the stack is running, stop the stack and start it back up with the command above.

## Logging

GraphDB has several rolling log files that are in the GraphDB home directory, making it difficult to use `docker logs <container_name>`. Instead, the logs are mounted to the local volume through the docker-compose file.

## Updating GraphDB Version

Updating GraphDB can be achieved by bumping the version in the docker-compose file. Data should be persisted through the mounted `graphdb-data` folder. The service should then be redeployed by bringing the stack down, and then back up (kludgy, with downtime).

## Integrating with Elasticsearch

The Knowledge Explorer webapp relies on integrating GraphDB with Elasticsearch. The Elasticsearch index is on a per-repository basis. This means that the Manhattan repository has its own Elasticsearch index. The Vienna repository has its own Elasticsearch index, etc. As of right now creating these ***is a manual process***. Elasticsearch indexes are created through SPARQL. The SPARQL queries for the indexes are found in the `scripts/` folder.

To integrate with Elasticsearch, run the sparql queries in the `scripts/` folder.

## Troubleshooting

### GraphDB is Unreachable

If GraphDB is not reachable,

1. Make sure the container is running
2. Make sure nginx is running
3. Check the nginx error logs
4. Check the graphdb logs
5. Restart the service

### GraphDB is Unresponsive

If GraphDB is running but is unresponsive,

1. Check if there's a data load process happening (can slow the service down)
2. Check the GraphDB logs
3. Restart the pod

### How do I check the logs if the container was killed?

1. `docker ps --all`
2. Get the killed container id
3. `docker logs <container_id>`
