# Elasticsearch

Text search & ranking for KnowWhereGraph

## Deploying

ElasticSearch can be independently deployed with

`docker-compose up`

## User Account

ElasticSearch is configured to be run under an authenticated account, `elastic` with the password set in the root `variables.env` file.

## Logs

ElasticSearch logs can be checked with `docker logs <container_id>`

## Creating the GraphDB Index

The SPARQL query to create the elasticsearch index is provided in `connector.sparql`. Enter the correct password and run the query through GraphDB's interface to create the index.
