#!/bin/bash

set -e # Exit on any error

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found! Please create it with required environment variables."
    exit 1
fi

export $(grep -v '^#' .env | xargs)

docker exec n8n-web n8n export:credentials --backup --output=/data/provision/credentials/
docker exec n8n-web n8n export:workflow --backup --output=/data/provision/workflows