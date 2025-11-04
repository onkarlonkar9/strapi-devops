# Use Node 18 LTS
FROM node:18

# Set working directory inside container
WORKDIR /app

# Copy dependency files first (for caching)
COPY package.json ./
# Only copy yarn.lock if it exists (optional, safe for first-time builds)
COPY yarn.lock* ./

# Install dependencies
RUN yarn install

# Copy entire project
COPY . .

# Build Strapi admin (this compiles the React-based admin panel)
RUN yarn build

# Expose Strapi's default port
EXPOSE 1337

# Start Strapi in production mode
CMD ["yarn", "start"]

