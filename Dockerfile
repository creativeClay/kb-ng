# Stage 1: Build the Angular application
FROM node:20-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application for production
RUN npm run build

# Stage 2: Serve with nginx
FROM nginx:alpine

# Copy built application from build stage
# Use the project dist output (not the /browser subfolder)
COPY --from=build /app/dist/kub-ng-1 /usr/share/nginx/html

# Optional: keep nginx.conf copy and rest unchanged
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
