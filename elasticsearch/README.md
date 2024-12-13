# Elasticsearch

Text search & ranking for KnowWhereGraph

## Deploying

The docker-compose file is used for deploying the service. Before deploying, set the password in the docker-compose file.

## Credentials

```
user: elastic
pass: <refer to docker-compose.yaml>
```

## Logs

ElasticSearch logs can be checked with `docker logs <container_id>`

## Creating the GraphDB Index

The SPARQL query to create the elasticsearch index is provided in `connector.sparql`. Enter the correct password and run the query through GraphDB's interface to create the index.
