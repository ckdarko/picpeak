# ---- Build backend ----
FROM node:20-bullseye AS backend
WORKDIR /app

# Install canvas build deps
RUN apt-get update && apt-get install -y \
    python3 \
    build-essential \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev

COPY backend ./backend
COPY package.json package-lock.json ./

RUN npm install --legacy-peer-deps

# Build backend TypeScript
RUN npm run build --prefix backend
