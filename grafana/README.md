# Grafana Dashboards

Dashboards for KnowWhereGraph service monitoring

## Monitoring & Access

The grafana deployment can be found on port `3000`` of the server that it's deployed on.

## Setting Up

Set the username and password in the docker-compose file; use these to sign into the dashboard. The data connection to prometheus and dashboard integrations are automatic and will be set up when the service is started.

Note: Folders that are mounted to the grafana container should have permissions set from `sudo chown -R 472:472`. Eg: `sudo chown -R 472:472 persistent_config/`.

## Development

Some important notes:

1. There are dashboard JSON definitions. These are JSON files that are the actual dashboard controls.
2. There are dashboard yaml definitions. These are yaml files that point to the JSON definitions.
3. The two definitions are mounted in different locations (check the docker-compose)
4. There is a `persistent_config` folder that's created by the Grafana process. This can be deleted between deployments
5. There is a `config` folder that contains important dashboard and Grafana config. Don't delete this

## Adding Dashboards

New dashboards should be added to the `provisioning/dashboards` folder and the sources (if needed) should be documented in this Readme, in the `Dashboard Sources` section.

## Dashboard Sources

The dashboards are taken from pre-designed packages, which are available on the [Grafana Labs Portal](https://grafana.com/grafana/dashboards/). The dashboard sources are linked below.

- [ElasticSearch](https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/)
- [Prometheus](https://grafana.com/grafana/dashboards/3662-prometheus-2-0-overview/)
- [Node Exporter](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
- [NGINX](https://grafana.com/grafana/dashboards/14900-nginx/)
- KWG-API: Custom
