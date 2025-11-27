# Stage 1: Build the Angular application
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm ci

# Copy source code and build the application for production
COPY . .
RUN npm run build

# DEBUG: list build output for verification
RUN ls -la /app/dist

# Stage 2: Serve with nginx
FROM nginx:alpine

WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy built app (use the dist folder, not the non-existent /browser subfolder)
COPY --from=build /app/dist/ ./
