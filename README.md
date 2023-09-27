# kwg-deployment

KnowWhereGraph's deployment system

## Overview

KnowWhereGraph's deployment is managed through docker-compose. It consists of several networked services and static sites. For an overview of the architecture and services involved, visit the [architecture](./architecture/) page.

Each service has its own docker-compose and optional Dockerfile, which are composed to create the stack.

## Deploying

There are a number of convenience commands in the makefile to manage the deployment.

### Production Environment

Production deployments make use of LetsEncrypt and certbot to auto-renew certificates.

To bring up the KnowWhereGraph stack run

`make start`

to bring down the stack,

`make stop`

For a complete list of commands, run

`make help`

### Development Environment

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

`make update <service_name>`

## System Requirements

Running KnowWhereGraph requires a large vertically scaled system. The suggested specifications are shown below.

| Component | Quantity |
|-----------|----------|
| Cores     | 15       |
| Memory    | 512 GB   |
| Disk      | 14 TB    |

## Development

To make changes, issue a pull request to the `main` branch. The deployment system mostly consists of Dockerfiles and configurations; both are linted on new commits.

### Adding New Services

New services should come with a README, a docker-compose.yml, and an optional Dockerfile. The makefile should be refactored to include the new service. If the service is resource intensive, provide a second docker-compose file that should work for local development.

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
