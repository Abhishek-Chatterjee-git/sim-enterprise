FROM node:22-alpine
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY tsconfig.json ./
COPY src ./src
RUN npm run build
COPY public ./public
COPY local-test ./local-test
COPY data/synthetic_customers.csv data/synthetic_employees.csv ./data/
USER node
EXPOSE 3000
CMD ["node", "dist/index.js"]
