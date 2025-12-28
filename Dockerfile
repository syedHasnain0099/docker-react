# Build stage
FROM node:22-alpine AS builder
WORKDIR /app

# Copy both package.json + lockfile for fast, deterministic installs
COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Run stage
FROM nginx:alpine

# Copy React build output to nginx html directory
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for EB health checks
EXPOSE 80

# ✅ Ensure nginx stays in foreground (container doesn't exit)
CMD ["nginx", "-g", "daemon off;"]
