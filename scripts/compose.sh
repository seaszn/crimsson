#!/bin/bash

set -e # Exit on any error

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found! Please create it with required environment variables."
    exit 1
fi

export $(grep -v '^#' .env | xargs)

# Source environment variables

for var in PG_DATABASE PG_USERNAME PG_PASSWORD; do
    if [ -z "${!var}" ]; then
        echo "Error: $var not set in .env"
        exit 1
    fi
done

if [ -z "${OLLAMA_MODELS}" ]; then
    echo "Warning: OLLAMA_MODELS not set in .env file. No models will be pulled."
    return 0
else
    IFS=',' read -ra MODEL_ARRAY <<<"${OLLAMA_MODELS}"
fi

# Function to show usage
show_usage() {
    echo "Usage: $0 [PROFILE]"
    echo ""
    echo "Available profiles:"
    echo "  cpu        - CPU-only mode (default)"
    echo "  gpu-nvidia - NVIDIA GPU support"
    echo "  gpu-amd    - AMD GPU support"
    echo ""
    echo "Examples:"
    echo "  $0              # Uses CPU profile"
    echo "  $0 cpu          # Uses CPU profile"
    echo "  $0 gpu-nvidia   # Uses NVIDIA GPU profile"
    echo "  $0 gpu-amd      # Uses AMD GPU profile"
    echo ""
    echo "Environment variables:"
    echo "  OLLAMA_MODELS  - Comma-separated list of models to pull (e.g., 'llama3.2,mistral,codellama')"
}

# Parse command line arguments
PROFILE=${1:-"cpu"}

case $PROFILE in
"cpu" | "gpu-nvidia" | "gpu-amd")
    echo "Using profile: $PROFILE"
    echo "Using models: ${OLLAMA_MODELS}"
    ;;
"-h" | "--help" | "help")
    show_usage
    exit 0
    ;;
*)
    echo "Invalid profile: $PROFILE"
    show_usage
    exit 1
    ;;
esac

echo "Starting services..."
echo ""

docker compose --profile "$PROFILE" up -d --build
echo ""

# POSTGRES
echo "Starting POSTGRES..."
until docker exec n8n-postgres pg_isready -U ${PG_USERNAME} -d ${PG_DATABASE} &>/dev/null; do
    echo "Waiting for POSTGRES to accept connections"
    sleep 2
done

echo "Successfully started POSTGRES"
echo ""

# OLLAMA
echo "Starting OLLAMA..."
until curl -s http://localhost:11434/api/tags >/dev/null 2>&1; do
    echo "Waiting for OLLAMA to accept connections..."
    sleep 2
done

echo "Pulling models..."
for model in "${MODEL_ARRAY[@]}"; do
    model=$(echo "$model" | xargs)

    if [ -z "$model" ]; then
        continue
    fi

    if curl -s http://localhost:11434/api/tags | grep -q "\"name\":\"${model}\"" 2>/dev/null; then
        echo "Model ${model} already exists, skipping..."
    else
        echo "Pulling model: ${model}"

        if docker exec n8n-ollama ollama pull "$model"; then
            echo "Successfully pulled model: $model"
        else
            echo "Failed to pull model: $model"
            exit 1
        fi
    fi
done

echo "Successfully started OLLAMA"
echo ""

# GRAFANA
echo "Starting GRAFANA..."
until curl -s http://localhost:9120 >/dev/null 2>&1; do
    echo "Waiting for Grafana to accept connections..."
    sleep 2
done
echo "Successfully started Grafana"
echo ""

echo "Starting N8N..."
until curl -s http://localhost:9110 >/dev/null 2>&1; do
    echo "Waiting for N8N to accept connections..."
    sleep 2
done

docker exec n8n-web n8n import:credentials --separate --input=/data/provision/credentials
docker exec n8n-web n8n import:workflow --separate --input=/data/provision/workflows

echo "Successfully started N8N"
echo ""

echo "All services are ready!"
echo ""
echo "Access N8N at: http://localhost:9110"
echo "Access MEM0 at: http://localhost:9130"
echo "Access NEO4J at: http://localhost:9150"
echo "Access QDRANT at: http://localhost:9140/dashboard"
echo "Access GRAFANA at: http://localhost:9120"
echo ""
