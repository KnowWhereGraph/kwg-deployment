
ORANGE='\033[0;31m'
DEFAULT='\033[0m'
GREEN='\033[0;32m'


BUILD_FILES_PROD := docker-compose.yaml -f nginx/docker-compose.prod.yaml -f nginx/metrics/docker-compose.yaml -f graphdb/docker-compose.prod.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.prod.yaml -f grafana/docker-compose.prod.yaml -f loki/docker-compose.yaml
BUILD_FILES_LOCAL := docker-compose.yaml -f nginx/docker-compose.local.yaml -f nginx/metrics/docker-compose.yaml -f graphdb/docker-compose.local.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.local.yaml -f grafana/docker-compose.local.yaml -f loki/docker-compose.yaml
BUILD_FILES_STAGE := docker-compose.yaml -f nginx/docker-compose.stage.yaml -f nginx/metrics/docker-compose.yaml -f graphdb/docker-compose.stage.yaml -f elasticsearch/docker-compose.yaml -f prometheus/docker-compose.yaml -f kwg-api/docker-compose.stage.yaml -f grafana/docker-compose.stage.yaml -f loki/docker-compose.yaml





echo "\n\n===== KnowWhereGraph Deployment Configuration Test ====="
echo "=====                                              ====="
echo "                  Checking SSL Certificates                  "
echo "                  .........................                  "

# Check for nginx's local certificates
if [ ! -f ./nginx/local-certs/cert.ped ]; then
    echo "${ORANGE}Warning${DEFAULT}: Local certificate not found in 'nginx/local-certs' folder!\nCertificates are required for deploying the system. Refer to the README.md for instructions on self signed certs."
else
    echo "${GREEN}Good${DEFAULT}: Located local certificates for nginx."
fi

# Check for graphdb's local certificates
if [ ! -f ./nginx/local-certs/cert.ped ]; then
    echo "${ORANGE}Warning${DEFAULT}: Local certificate not found in 'graphdb/local-certs' folder!\nGraphDB may not process SSL data properly!"
else
        echo "${GREEN}Good${DEFAULT}: Located local certificates for GraphDB."
fi

echo "\n                  Checking Web Applications                    "
echo "                  .........................                    "

# Check for the faceted search folder
if [ ! -d ./nginx/sites/kwg-faceted-search ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate the faceted search folder. Has it been cloned into nginx/sites?"
else
    echo "${GREEN}Good${DEFAULT}: Located the Faceted Search folder."
fi

# Check for Faceted Search's build directory
if [ ! -d ./nginx/sites/kwg-faceted-search/dist/faceted-search ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate the Faceted Search build directory. Try building using the docker-compose files within the faceted search folder."
else
    echo "${GREEN}Good${DEFAULT}: Located the Faceted Search build artifacts."
fi

# Check for KW Panels
if [ ! -d nginx/sites/kw-panels ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate the KW-Panels. Try cloning the repository into nginx/sites."
else
    echo "${GREEN}Good${DEFAULT}: Located the kw-panels folder."
fi

# Check for Node Browser src
if [ ! -d nginx/sites/node-browser/node-browser ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate the node browser. Try cloning the repository into nginx/sites."
else
    echo "${GREEN}Good${DEFAULT}: Located the node browser source."
fi

# Check for Node Browser dist
if [ ! -d nginx/sites/node-browser/node-browser/dist/node-browser ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate the node browser's build artifacts. Try building the source with its docker-compose file.\n"
else
    echo "${GREEN}Good${DEFAULT}: Located the node browser build artifacts."
fi

echo "\n                  Checking Web Artifacts                      "
echo "                    ......................                      "


# Check for void file
if [ ! -f nginx/sites/void/void.ttl ]; then
    echo "${ORANGE}Error${DEFAULT}: Void ttl file not detected!\n This file comes from the kwg-ontologies repository. Check the makefile for the clone command."
else
    echo "${GREEN}Good${DEFAULT}: Located the void.ttl file."
fi


# Check for robots.txt
if [ ! -f nginx/sites/robots.txt ]; then
    echo "${ORANGE}Error${DEFAULT}: Failed to locate robots.txt"
else
    echo "${GREEN}Good${DEFAULT}: Located the robots.txt"
fi

echo "\n                  Checking System Artifacts                "
echo "                    .........................                "

# Check for an exiting Grafana database file
if [ -f grafana/persistent_storage/grafana.db ]; then
    echo "${ORANGE}Warning${DEFAULT}: Found an existing Grafana database file. Any Grafana password changes will not persist."
else
    echo "${GREEN}Good${DEFAULT}: Failed to find an existing Grafana database file. A new one will be created"
fi

# Check for any existing GraphDB repositories

if [ -d graphdb/ ]; then
    echo "${ORANGE}Info${DEFAULT}: Found existing GraphDB repositories. These will be loaded when GraphDB starts."
else
    echo "${GREEN}Info${DEFAULT}: Failed to find any GraphDB repositories. GraphDB will not be started with any repositories."
fi

echo ""
echo""


echo "\n                  Checking Variables                       "
echo "                    .........................                "

# Check for an exiting Grafana database file
if [ -f grafana/persistent_storage/grafana.db ]; then
    echo "${ORANGE}Warning${DEFAULT}: Found an existing Grafana database file. Any Grafana password changes will not persist."
else
    echo "${GREEN}Good${DEFAULT}: Failed to find an existing Grafana database file. A new one will be created"
fi

# Check for any existing GraphDB repositories

if [ -d graphdb/ ]; then
    echo "${ORANGE}Info${DEFAULT}: Found existing GraphDB repositories. These will be loaded when GraphDB starts."
else
    echo "${GREEN}Info${DEFAULT}: Failed to find any GraphDB repositories. GraphDB will not be started with any repositories."
fi

echo ""
echo""