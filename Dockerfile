FROM node:20-alpine
WORKDIR /app

# Install dependencies
COPY package*.json tsconfig.json ./
RUN npm install

# Copy source code and assets
COPY src/ ./src/
COPY public/ ./public/
COPY public-admin/ ./public-admin/
COPY data/ ./data/
COPY scripts/ ./scripts/

EXPOSE 3000

ENV NODE_ENV=production

CMD ["npx", "tsx", "src/index.ts"]
