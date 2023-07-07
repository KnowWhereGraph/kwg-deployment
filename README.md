# kwg-deployment

KnowWhereGraph's deployment system

## Overview

KnowWhereGraph's deployment is managed through docker-compose. It consists of several networked services and static sites. For an overview of the architecture and services involved, visit the [architecture](./architecture/) page.

Each service has its own docker-compose and linked Dockerfile. The stack is created by composing each service's docker-compose.

## Deploying

There are a number of convenience commands in the makefile.

To bring up the KnowWhereGraph stack run

`make start`

## System Requirements

Running KnowWhereGraph requires a large vertically scaled system. The suggested specifications are shown below.

| Component | Quantity |
|-----------|----------|
| Cores     | 80       |
| Memory    | 512 GB   |
| Disk      | 14 TB     |

## Development

To make changes, issue a pull request to the `main` branch. The deployment system mostly consists of Dockerfiles and configurations; both are linted on new commits.

### Adding New Services

New services should come with a README, a docker-compose.yml, and an optional Dockerfile. The makefile should be refactored to include the new service.

### Testing

Because of KnowWhereGraph's graph resource requirements, it's difficult to create an environment that mimics a production setting. To test, it's suggested that the system is scaled down to match the table below. The lower system requirements come at the expense of not being able to load much data into the graph. Adjust the settings as needed based on data testing needs.

| Component | Quantity |
|-----------|----------|
| Cores     | 8       |
| Memory    | 8 GB   |
| Disk      | 20 GB     |

### Reviewing

When reviewing architecture changes

- Test the changes locally before approving
- Check
  - Is the architecture diagram updated?
  - Are there any changes to existing documentation that should be made?
  - Is there new documentation that needs to be added?
  - Will this change possible effect other services?
- Are there any stakeholders that might need to be notified of the change?
