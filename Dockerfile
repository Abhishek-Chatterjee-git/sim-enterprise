# Multi-stage production Dockerfile for Simulated Enterprise
FROM node:22-alpine AS builder

WORKDIR /app

# Copy root workspace configurations
COPY package.json package-lock.json ./
COPY shared/package.json ./shared/
COPY agent/package.json ./agent/
COPY sim-enterprise/ecom-app/package.json ./sim-enterprise/ecom-app/

RUN npm ci

# Copy sources
COPY shared ./shared
COPY agent ./agent
COPY sim-enterprise/ecom-app ./sim-enterprise/ecom-app

# Build all packages
RUN npm run build:shared
RUN npm run build:ecom

# Production runtime stage
FROM node:22-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000
ENV AGENT_PORT=5000

# Copy node_modules and built dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/shared/package.json ./shared/
COPY --from=builder /app/shared/dist ./shared/dist
COPY --from=builder /app/sim-enterprise/ecom-app/package.json ./sim-enterprise/ecom-app/
COPY --from=builder /app/sim-enterprise/ecom-app/dist ./sim-enterprise/ecom-app/dist
COPY --from=builder /app/sim-enterprise/ecom-app/public ./sim-enterprise/ecom-app/public

WORKDIR /app/sim-enterprise/ecom-app

EXPOSE 3000 5000 3001

CMD ["node", "dist/index.js"]
