FROM node:22-bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates openssl \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY deploy/render/start-agent.mjs ./start-agent.mjs
ENV AGENT_DATA_DIR=/var/lib/d-fortress/data AGENT_HOST=127.0.0.1
CMD ["node", "start-agent.mjs"]
