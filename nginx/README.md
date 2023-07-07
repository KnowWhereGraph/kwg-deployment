# kwg-nginx

The NGINX service used to route traffic throughout the KnowWhereGraph stack

## Overview

KnowWhereGraph has a handful of services that require networking capabilities. These include GraphDB (sparql endpoint & workbench), ElasticSearch, and static sites. NGINX is both our load balancer and reverse proxy, serving requests to these services.

The NGINX configuration files are templated with environment variables, which can be customized in the docker-compose file. For more information on how the configuration files are generated from the templates refer to [this](https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration-new-in-119) documentation page.

### HTTPS

KnowWhereGraph is meant to operate under HTTPS.  Certbot is used with LetsEncrypt to issue new certificates. These need to be reissued every three months.

## Deploying

To deploy NGINX, use the docker-compose command below

`docker-compose up`

To bring the service down, run

`docker-compose down`

## Logging

The NGINX logs are found in the container's /var/logs/nginx, which is mounted locally at `./logs`. For more verbose logging, refer to the NGINX Docker image documentation and modify the deployment script to include any additional flags.
