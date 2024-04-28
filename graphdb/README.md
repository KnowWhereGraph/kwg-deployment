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

