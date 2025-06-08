# Qdrant Service

This component runs an instance of **Qdrant**, a vector search engine designed for storing and querying high-dimensional embeddings. It is commonly used to enable semantic search and context-aware retrieval in AI-driven workflows.

The service exposes both HTTP (`6333`) and gRPC (`6334`) interfaces and persists data using a shared Docker volume. It integrates well with systems that generate embeddings, such as language models or machine learning tools, and can be connected to N8N agents for enhanced automation capabilities.

Qdrant is efficient for real-time similarity searches, and while it's tailored specifically for vector data, it can be a powerful part of a broader workflow that includes AI, recommendation systems, or conversational agents.
