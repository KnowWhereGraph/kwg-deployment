
ORANGE='\033[0;31m'
DEFAULT='\033[0m'
GREEN='\033[0;32m'

echo "===== KnowWhereGraph Install Validation Tool ====="

echo "\n                  Checking SSL Certificates...                  \n"

# Check for nginx's local certificates
if [ ! -f nginx/local-certs/cert.ped ]; then
    echo "${ORANGE}Warning${DEFAULT}: Local certificate not found in 'nginx/local-certs' folder!\nCertificates are required for deploying the system. Refer to the README.md for instructions on self signed certs."
else
        echo "${GREEN}Good${DEFAULT}: Located local certificates for nginx."
fi

# Check for graphdb's local certificates
if [ ! -f nginx/local-certs/cert.ped ]; then
    echo "${ORANGE}Warning${DEFAULT}: Local certificate not found in 'graphdb/local-certs' folder!\nGraphDB may not process SSL data properly!"
else
        echo "${GREEN}Good${DEFAULT}: Located local certificates for GraphDB."
fi

echo "\n                  Checking Web Applications...                    \n"
# Check for the faceted search folder
if [ ! -f nginx/sites/kwg-faceted-search ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate the faceted search folder. Has it been cloned into nginx/sites?"
else
        echo "${GREEN}Good${DEFAULT}: Located the Faceted Search folder."
fi

# Check for Faceted Search's build directory
if [ ! -f nginx/sites/kwg-faceted-search/dist/faceted-search ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate the Faceted Search build directory. Try building using the docker-compose files within the faceted search folder."
else
        echo "${GREEN}Good${DEFAULT}: Located the Faceted Search build artifacts."
fi

# Check for void file
if [ ! -f nginx/sites/void/void.ttl ]; then
    echo "${ORANGE}Warning${DEFAULT}: Void ttl file not detected!\n"
else
        echo "${GREEN}Good${DEFAULT}: Located the void.ttl file."
fi

# Check for KW Panels
if [ ! -f nginx/sites/kw-panels ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate the KW-Panels. Try cloning the repository into nginx/sites.\n"
else
        echo "${GREEN}Good${DEFAULT}: Located the kw-panels folder."
fi

# Check for Node Browser src
if [ ! -f nginx/sites/node-browser/node-browser ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate the node browser. Try cloning the repository into nginx/sites.\n"
else
        echo "${GREEN}Good${DEFAULT}: Located the node browser source."
fi

# Check for Node Browser dist
if [ ! -f nginx/sites/node-browser/node-browser/dist/node-browser ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate the node browser's build artifacts. Try building the source with its docker-compose file.\n"
else
        echo "${GREEN}Good${DEFAULT}: Located the node browser build artifacts."
fi

# Check for robots.txt
if [ ! -f nginx/sites/robots.txt ]; then
    echo "${ORANGE}Warning${DEFAULT}: Failed to locate robots.txt.\n"
else
        echo "${GREEN}Good${DEFAULT}: Located the robots.txt"
fi