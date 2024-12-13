# kwg-architecture

KnowWhereGraph's networking and service architecture

## Overview

KnowWhereGraph follows a Monolith reference design pattern. The components are tightly coupled and are all deployed together.

### Architecture Diagram

The diagram below shows the services and static sites behind NGINX. The observability services are a bit noisy.

![](./architecture.png)

### Networking

NGINX serves as the load balancer and reverse proxy to internal services. Several static sites are served directly by NGINX. These include the ontology description pages, the [faceted search](https://github.com/KnowWhereGraph/kwg-faceted-search), the Node Browser, and void description file.

Services within the Docker network use container hostnames. For example, the API is referenced by `kwg-api:8080`.

### Observability Platform

The observability stack consists of

1. Loki: Log aggregation
2. Metric Exporters: Exports service metrics from various services (api, elasticsearch, etc) to Prometheus
3. Prometheus: Stores the metrics
4. Grafana: For viewing/searching logs, live metrics, alerting
