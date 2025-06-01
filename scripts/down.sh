#!/bin/bash

set -e # Exit on any error

export $(grep -v '^#' .env | xargs)

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

docker compose -f compose.yaml \
    -f ./services/n8n/compose.yaml \
    -f ./services/ollama/compose.yaml \
    -f ./services/qdrant/compose.yaml \
    -f ./services/mem0/compose.yaml \
    --profile "$PROFILE" down
