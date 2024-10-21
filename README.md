# kwg-deployment

KnowWhereGraph's deployment system

## Overview

KnowWhereGraph's deployment is managed through docker-compose. It consists of several networked services and static sites. For an overview of the architecture and services involved, visit the [architecture](./architecture/) page.

Each service has its own docker-compose and optional Dockerfile, which are composed to create the stack. When the behavior of a service depends on where it's deployed (locally, on the staging server, on the production server) there will be different docker-compose files for each environment. When the service is agnostic, there will be only one docker-compose file.

Some services are coupled with prometheus logging scrapers. In these cases, the associated scraper is included in the services' docker-compose file.

For monitoring the deployment, refer to the [Grafana Readme](./grafana/README.md).

## Deploying

There are a number of convenience commands in the makefile to manage the deployment. The deployment has three modes:

1. Local: When the stack is brought up on your own machine
2. Stage: When the stack is brought up on staging.knowwheregraph.org
3. Prod: When the stack is brought up on stko-kwg.geog.ucsb.edu

For a complete list of commands, run

`make help`

### All Environments

The following steps aren't automated and will need to be done *before* bringing the stack online.

1. Run `fetch-repositories.sh` to retrieve the web-applications and API
2. Build the faceted search files
3. Build the node browser files
4. Put the ssl certificates in `nginx/local-certs`
5. Put the GraphDB license in `graphdb/license`
6. Modify `variables.env` to specify the name of the GraphDB repository the `sparql/` endpoint should query
7. Modify `variables.env` with the Elasticsearch password
8. Modify `variables.env` with the server name - without `http` or `www` (localhost/staging.knowwheregraph.org/stko-kwg.geog.ucsb.edu)
9. On a new server, install the loki docker plugin with `docker plugin install grafana/loki-docker-driver:main--alias loki  --grant-all-permissions`

### Production Environment

Running KnowWhereGraph requires a large vertically scaled system. The suggested specifications are shown below.

| Component | Quantity |
|-----------|----------|
| Cores     | 15       |
| Memory    | 512 GB   |
| Disk      | 14 TB    |

The production docker-compose files are designed specifically to run on https://stko-kwg.geog.ucsb.edu. If this address ever changes, the production docker-compose files should be modified accordingly.

To bring up the KnowWhereGraph stack run

`make start-prod`

to bring down the stack,

`make stop-prod`

### Staging Environment

The staging environment is meant to be run on https://staging.knowwheregraph.org.

To run the staging stack,

`make start-stage`

to bring down the stack,

`make stop-stage`

### Local Environment

Because of KnowWhereGraph's graph resource requirements, it's difficult to create an environment that mimics a production setting. To test, it's suggested that the system is scaled down to match the table below. The lower system requirements come at the expense of not being able to load much data into the graph. Adjust the settings as needed based on data testing needs.

| Component | Quantity |
|-----------|----------|
| Cores     | 1       |
| Memory    | 8 GB   |
| Disk      | 20 GB     |

#### NGINX Certificates

LetsEncrypt can't be used for local HTTPS . More information can be found on LetsEncrypt's [website](https://letsencrypt.org/docs/certificates-for-localhost/). This deployment architecture makes use of self signed certificates for localhost.

1. Generate the local certs
2. Name the `*.cert` file `cert.cert`
3. Name the `*.key` file `key.key`
4. Place them in `./nginx/local-certs`

#### Running Locally

### Updating Environmental Variables

Some evironmental variables are kept in the `variables.env`. These variables are used across deployments and within NGINX; they can be injected into any container.

`GRAPH_DB_HOSTNAME`: The name for the graphdb service

`ES_HOSTNAME`: The name for the elasticsearch service

`ELASTIC_PASSWORD`: The password for elasticsearch

`API_HOSTNAME`: The name for the KWG API service

`SERVER_NAME`: The hostname where things are deployed (localhost | staging.knowwheregraph.org | stko-kwg.geog.ucsb.edu). Without http or https

`CURRENT_REPOSITORY_NAME`: Used as the repository that `/sparql` endpoint requests are sent to

## Updating Services

Right now, when a single service is updated, the stack needs to be brought down, and then back up. This is inconvenient, and will be addressed in the future.

To update any of the webapps, use `git pull` to update them from source and follow the repository readme for building. Restarting nxing isn't required for the changes to become live.

## Development

To make changes, issue a pull request to the `main` branch. The deployment system mostly consists of Dockerfiles and configurations; both are linted on new commits.

### Adding New Services

New services should come with a README, a docker-compose.yaml, and an optional Dockerfile. The makefile should be refactored to include the new service. If the service is resource intensive or requires different behavior for different deployment locations, provide a additional docker-compose files (docker-compose.local.yaml. docker-compose.stage.yaml).

### Adding new HTTP Sites

New web applications should be added as built html/js artifacts. These files should be placed in `nginx/sites` and a corresponding nginx rule should be added to the default config file. Traffic should be routed to that application's folder.

### Reviewing

When reviewing architecture changes

- Test the changes locally before approving
- Check
  - Is the architecture diagram updated?
  - Are there any changes to existing documentation that should be made?
  - Is there new documentation that needs to be added?
  - Will this change possible effect other services?
  - Was the makefile updated?
  - Will this work locally, on staging, and on production?
- Are there any stakeholders that might need to be notified of the change?
