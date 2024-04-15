# kwg-deployment

The NGINX service used to route traffic throughout the KnowWhereGraph stack. Think of this as the "mail room".

## Overview

KnowWhereGraph has a handful of services that require networking capabilities. These include GraphDB (sparql endpoint & workbench), ElasticSearch, API, and static sites. NGINX is both our load balancer and reverse proxy, serving requests to and between these services.

The NGINX configuration files are templated with environment variables, which can be customized in the docker-compose file. For more information on how the configuration files are generated from the templates refer to [this](https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration-new-in-119) documentation page.

## Deploying

Deploying nginx without using the make command is *not* recommended and most likely not necessary. If you know what you're doing and need to, you can with

`docker-compose up`

To bring the service down, run

`docker-compose down`

## Certificates

Certificates for local development need to be manually generated and added to the `local-certs` directory.

From the LetsEncrypt website, local certificates can be created by running the following from this directory,

```bash
openssl req -x509 -out local-certs/cert.crt -keyout local-certs/key.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
```

The certificate will also have to be added to your local machine for your browser to trust; this is platform dependent.

https://stackoverflow.com/questions/7580508/getting-chrome-to-accept-self-signed-localhost-certificate

https://javorszky.co.uk/2019/11/06/get-firefox-to-trust-your-self-signed-certificates/

## Logging

The NGINX logs are found in the container's /var/logs/nginx, which is mounted locally at `./nginx/logs`. For more verbose logging, refer to the NGINX Docker image documentation and modify the deployment script to include any additional flags.
