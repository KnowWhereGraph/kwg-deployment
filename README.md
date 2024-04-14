# kwg-deployment

KnowWhereGraph's deployment system

## Overview

KnowWhereGraph's deployment is managed through docker-compose. It consists of several networked services and static sites. For an overview of the architecture and services involved, visit the [architecture](./architecture/) page.

Each service has its own docker-compose and optional Dockerfile, which are composed to create the stack. Some services are coupled with prometheus logging scrapers. In these cases, the associated scraper is included in the services' docker-compose file.

For monitoring the deployment, refer to the [Grafana Readme](./grafana/README.md).

## Deploying

There are a number of convenience commands in the makefile to manage the deployment. Before running them, ensure that *all* necessary repositories are present by running `sh fetch-repositories.sh`.

### All Environments

Regardless of the environment, the web applications need to be added to the project from their various repositories. Refer to each application on how to build it, using the config that you need and add them to `nginx/sites`. For example, when the environment is for staging, build the staging versions of the webapps and place the build in the `nginx/sites`` folder. When the environment is for a localhost deployment, use the associated localhost builds. The nginx config file has rules that map the URI space to the specific folder.

1. Build the faceted search files
2. Build the node browser files
3. Build the kwg-api image

### Production Environment

Running KnowWhereGraph requires a large vertically scaled system. The suggested specifications are shown below.

| Component | Quantity |
|-----------|----------|
| Cores     | 15       |
| Memory    | 512 GB   |
| Disk      | 14 TB    |

Production deployments make use of LetsEncrypt and certbot to auto-renew certificates.

To bring up the KnowWhereGraph stack run

`make start`

to bring down the stack,

`make stop`

For a complete list of commands, run

`make help`

The environmental variables should be updated during production deployments to match the correct URI space and authentication patterns.

### Development/Localhost Environment

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

Use `make start-dev` and `make stop-dev` to use less resource-intensive and dev environment.

### Updating Services

The makefile has several convenience methods for updating services. They take the form

`make update-<service_name>`

This will remove the service and replace it with a new one. Note that this will cause a brief service interruption; rolling updates aren't supported at this time.

Check the makefile for available update commands

### Updating Environmental Variables

Environmental variables are kept in the `variables.env`. These variables are used across deployments and within NGINX; they can be injected into any container.

`GRAPH_DB_HOSTNAME`: The name for the graphdb service

`ES_HOSTNAME`: The name for the elasticsearch service

`API_HOSTNAME`: The name for the KWG API service

`SERVER_NAME`: The hostname where things are deployed (localhost | staging.knowwheregraph.org | stko-kwg.geog.ucsb.edu). Without http or https

`CURRENT_REPOSITORY_NAME`: Used as the repository that `/sparql` endpoint requests are sent to

## Development

To make changes, issue a pull request to the `main` branch. The deployment system mostly consists of Dockerfiles and configurations; both are linted on new commits.

### Adding New Services

New services should come with a README, a docker-compose.yaml, and an optional Dockerfile. The makefile should be refactored to include the new service. If the service is resource intensive, provide a second docker-compose file that should work for local development.

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
- Are there any stakeholders that might need to be notified of the change?
