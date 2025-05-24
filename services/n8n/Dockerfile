FROM n8nio/n8n:latest

USER root

COPY ./credentials /data/provision/credentials
COPY ./workflows /data/provision/workflows

RUN chown -R node:node /data/provision

USER node

# Set environment variables for auto-provisioning
ENV N8N_TEMPLATES_ENABLED=true
ENV N8N_ONBOARDING_FLOW_DISABLED=true

# Expose the default n8n port
EXPOSE 5678