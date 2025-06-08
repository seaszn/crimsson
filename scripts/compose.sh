#!/bin/sh

set -e

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found! Please create it with required environment variables."
    exit 1
fi

# export $(grep -v '^#' .env | xargs)

# Create the external network
# docker network create n8n-network

docker compose --env-file .env up -d --build
