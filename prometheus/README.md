# Prometheus

Log aggregations for KWG services

## Metrics

The Prometheus service connects to other services that expose compliant endpoints. Some services such as GraphDB expose these natively, which other services such as ElasticSearch require log-scraping containers to collect and expose the metrics through an API.

Rather than using Prometheus to view the metrics, the recommended way is to view them using Grafana.

## Adding Metrics

To add metrics, make new additions to the `prometheus.yml` file. The service name should be the corresponding container name, as these reside in the same docker network.
