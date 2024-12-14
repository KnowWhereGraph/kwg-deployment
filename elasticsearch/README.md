# Elasticsearch

Text search & ranking for KnowWhereGraph

## Credentials

Credentials need to be set for Elasticsearch before the stack is deployed. Set this in the docker-compose.yaml file.

```text
user: elastic
pass: <refer to docker-compose.yaml>
```

## Logs

ElasticSearch logs can be checked with `docker logs <container_id>`

## Creating the GraphDB Index

The SPARQL query to create the elasticsearch index is provided in `connector.sparql`. Enter the correct password and run the query through GraphDB's interface to create the index.
