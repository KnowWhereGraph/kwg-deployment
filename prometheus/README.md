# Prometheus

Log aggregations for KWG services

## Metrics

The Prometheus service connects to other services that expose compliant endpoints. Some services such as GraphDB expose these natively, which other services such as ElasticSearch require log-scraping containers to collect and expose the metrics through an API.

Rather than using Prometheus to view the metrics, the recommended way is to view them using Grafana.

## Credentials

Prometheus is being authorization (and should remain so). To set the password, follow the steps laid out in the [Prometheus Docs](https://prometheus.io/docs/guides/basic-auth/).

## Prometheus in the Browser

Prometheus can be reached at `<deployment_url>/prometheus/graph`. Sign in using the credentials set in the credentials section.

## Adding Metrics

To add metrics, make new additions to the `prometheus.yaml` file. The service name should be the corresponding container name, as these reside in the same docker network.
