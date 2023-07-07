# kwg-architecture

KnowWhereGraph's networking and service architecture

## Overview

NGINX serves as the load balancer and reverse proxy to internal services. Several static sites are served directly by NGINX. These include the ontology description pages and the [faceted search](https://github.com/KnowWhereGraph/kwg-faceted-search). The files reside on the host's disk which is mounted by NGINX.

GraphDB is the only service behind NGINX that's available to the public. GraphDB communicates with ElasticSearch through its [ES Connector](https://graphdb.ontotext.com/documentation/10.0/elasticsearch-graphdb-connector.html).


### Architecture Diagram

The diagram below shows the services and static sites behind NGINX.

![](./architecture.png)


### Gotcha's
- The SPARQL endpoint is routed through phuzzy.link
- Static sites are served through phuzzy.link
- NGINX routes _some_ traffic to the host (un-dockerized components)