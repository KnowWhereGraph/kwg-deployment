# kwg-deployment

KnowWhereGraph's deployment system

## Overview

KnowWhereGraph's reference architecture is a Monolith. It consists of several networked services and static sites, all intertwined and dependant on each other. The stack is generally brought up all at once. Individual services can be updated in isolation, but there will be downtime for end users. For an overview of the architecture and services involved, visit the [architecture](./architecture/) page.

At a high level, each service has its own folder. Within each folder, there's at least one docker compose file and a Dockerfile when container customization is needed. For each environment (stage, prod, local) there's a corresponding docker-compose file that has configurations specific for said environment.

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

1. Run `make repository-setup` to retrieve the web-applications and API
2. Build the faceted search files
3. Build the node browser files
4. Put the ssl certificates in `nginx/local-certs`
5. Put the GraphDB license in `graphdb/license`
6. Modify `variables.env` to specify the name of the GraphDB repository the `sparql/` endpoint should query
7. Modify `variables.env` with the Elasticsearch password
8. Modify `variables.env` with the server name - without `http` or `www` (localhost/staging.knowwheregraph.org/stko-kwg.geog.ucsb.edu)
9. On the bare metal server, install the loki docker plugin with `docker plugin install grafana/loki-docker-driver:main--alias loki  --grant-all-permissions`. This scrapes the docker system for logs.
10. Set the Prometheus credentials (see readme file in `./prometheus/`)
11. Set the Grafana credentials (see readme file in `./grafana/`)
12. Set the Elasticsearch credentials (see readme file in `./elasticsearch/`)
13. Set the prometheus credentials through Grafana > Datasources > Prometheus
14. Run the validation tool with `sh validate.sh`

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

#### Setting Certificates (NGINX and GraphDB)

LetsEncrypt can't be used for local HTTPS . More information can be found on LetsEncrypt's [website](https://letsencrypt.org/docs/certificates-for-localhost/). This deployment architecture makes use of self signed certificates for localhost.

1. Generate the local certs
2. Name the `*.cert` file `cert.pem`
3. Name the `*.key` file `key.pem`
4. Place them in `./nginx/local-certs`

GraphDB also needs its own set of certificates. These can be generated with `keytool -genkey -alias graphdb -keyalg RSA` and should be placed in `graphdb/nginx/local-certs/`.

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


## Administration

### Redeploy Individual Services

To update a single service, first find it with `docker ps`. If it's graphdb, use `make stop graphdb`. Otherwise use `docker stop container_id` followed by `docker rm container_id`. Finally, use `make start-env` to start the service.

### Updating Services

Update the docker compose file, update the deployment's kwg-deployment local repo. Use the "Redeploy Individual Services" docs for updating the single service.

### Viewing Container Logs & Metrics

Container logs and metrics can be found through Grafana. This is at your-host.org/metrics. View the grafana readme for a guide on reading container logs.


### Loading Data Into GraphDB for the First Time

#### Step 1: Create Database Index with Preload

The [preload](https://graphdb.ontotext.com/documentation/10.8/loading-and-updating-data.html) tool is used to create the database index offline (GraphDB can't be running). This tool is Ontotext's answer to loading large graphs. It is important
 to note that it *does not perform inference*; the ontologies must be loaded after.

The preload tool and GraphDB share the same docker image however, they differ on the entrypoint command to the container. When using the preload tool, the `preload` command is used vs running the GraphDB binary. Because of this, there are *two
* docker compose flavors.

To use the preload compose file,

1. Ensure `kwg-deployment/graphdb/graphdb-data/home/data/repositories/KWG/config.ttl` exists
2. Place all data to be loaded in `kwg-deployment/graphdb/graphdb-data/import-data`
3. Run `make start-env`

This process may take days! It's advised to run the above command in a tmux session

#### Step 2: Load Ontologies

1. Mash all ontologies into one large ontology, and upload that file or upload each individually
2. Wait for inferencing to complete (may take days)

### Loading a Repository Into a Fresh GraphDB Instance

GraphDB's architecture allows for swapping out repositories by modifying certain filesystem artifacts. These artifacts are found in `kwg-deployment/graphdb/graphdb-data/home/data/repositories`. This can be used several different ways.

One example of this is transferring the staging database to production by replacing production's KWG folder with staging's. This is done to avoid waiting for inferencing and loading overheads, given that if we're ready to promote staging to pr
oduction the data should be okay.

The above case is a general case of moving the GraphDB repository off one host, and onto another. The steps to do this are,

1. Obtain a new computer with specs to run the graph ("host computer")
2. git clone the deployment repository
3. Create a new docker-compose file for your host, in each service (or rename stko-kwg)
5. Go through all the setup steps
6. Stop GraphDB
7. ssh to host that has KWG ("source computer")
8. Stop GraphDB
9. Check the name of the repository being transferred
10. Ensure this repository does not exist on the host computer
11. rsync or ssh the directory over to the host computer's directory (eg, if the kwg-deployment repo's root is `~`, the destination is `/kwg-deployment/graphdb/graphdb-data/home/data/repositories/KWG`)
12. Switch to the host computer
13. Once finished, start GraphDB; startup may take several hours
14. Set up connectors
15. Generate knowledge explorer cache
16. Set up certs


### Common Issues

#### Passwords being asked in Grafana

If login popups are happening while viewing dashboards, the passwords have been set up incorrectly when starting the stack. Delete the grafana db files and go through the setup again.

#### HTTPS Broken

When there's an HTTPS issue, it could be several things

1. The certs have expired
2. The new certs aren't being mounted into the nginx container
3. The certs aren't named properly (see setup guide)

Use `docker exec -it nginx_container_id bash` to check the mount location to see if the certs are there and have the proper extension

#### {Some static site} Isn't found

When a site like the node browser of knowledge explorer isn't found,

1. Has the project been built?
2. Are the build artifacts mounted into the nginx container?
3. Are the permissions okay?

Use `docker exec -it nginx_container_id bash` to check the static sites; check to see if it's there, the permissions, etc

#### GraphDB is down

1. Check to see if the container is running
2. If it's not, `make start-env`
3. If it is, and the process appears hung - stop at your own risk with make `stop-graphdb`
4. Once stopped, start again with `make start-env`