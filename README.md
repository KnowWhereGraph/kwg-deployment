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

### Development/Localhost Environment

Because of KnowWhereGraph's graph resource requirements, it's difficult to create an environment that mimics a production setting. To test, it's suggested that the system is scaled down to match the table below. The lower system requirements come at the expense of not being able to load much data into the graph. Adjust the settings as needed based on data testing needs.

| Component | Quantity |
|-----------|----------|
| Cores     | 1       |
| Memory    | 8 GB   |
| Disk      | 20 GB     |

LetsEncrypt can't be used for local HTTPS . More information can be found on LetsEncrypt's [website](https://letsencrypt.org/docs/certificates-for-localhost/). This deployment architecture makes use of self signed certificates for localhost.

The GraphDB and NGINX deployments comes with docker-compose files with development presents.

Use `make start-dev` and `make stop-dev` to use less resource-intensive containers.

### Updating Services

The makefile has several convenience methods for updating services. They take the form

`make update-<service_name>`

This will remove the service and replace it with a new one. Note that this will cause a brief service interruption; rolling updates aren't supported at this time.

Check the makefile for available update commands

## Development

To make changes, issue a pull request to the `main` branch. The deployment system mostly consists of Dockerfiles and configurations; both are linted on new commits.

### Adding New Services

New services should come with a README, a docker-compose.yml, and an optional Dockerfile. The makefile should be refactored to include the new service. If the service is resource intensive, provide a second docker-compose file that should work for local development.

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
