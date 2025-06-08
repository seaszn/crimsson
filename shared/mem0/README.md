# mem0 OpenMemory

This component provides memory capabilities to N8N agents through the **mem0 OpenMemory** system. It includes:

### `mem0_mcp`

An API service that interacts with language models (e.g., OpenAI) and stores memory embeddings in Qdrant. It enables agents to retrieve and build contextual understanding over time by referencing previous interactions.

### `mem0_ui`

A web-based interface to browse and explore stored memory data. It helps visualize the memory structure and assess what information is being retained or retrieved by the agents.

Together, these services allow N8N agents to maintain persistent memory and context across sessions, enabling more adaptive and personalized automation flows.
