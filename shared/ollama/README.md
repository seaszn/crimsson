# Ollama Service

This component runs **Ollama**, a local large language model (LLM) server that allows N8N agents to use powerful AI models without relying on external APIs. It supports both CPU and GPU execution, with separate profiles for NVIDIA and AMD hardware acceleration.

## Modes

- **`ollama-cpu`**: Runs the LLM server on CPU. Suitable for general use or lower-powered machines.
- **`ollama-gpu`**: Uses NVIDIA GPU for faster inference and model loading.
- **`ollama-gpu-amd`**: Uses AMD GPUs via ROCm for hardware-accelerated inference.

## Usage

Ollama provides a local HTTP API on port `11434`, which N8N agents can use to run LLM prompts, stream completions, or perform AI-driven tasks without depending on third-party cloud services. It’s useful for privacy-sensitive workflows, offline operation, or when reducing dependency on OpenAI or similar providers.

Memory and model data are stored in a shared volume for persistence across sessions.
