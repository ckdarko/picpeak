# ---- Build frontend ----
FROM node:20-bullseye AS frontend
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

COPY frontend ./frontend
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps
RUN npm run build --prefix frontend

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

# ---- Final runtime image ----
FROM node:20-bullseye
WORKDIR /app

COPY --from=backend /app/backend ./backend
COPY --from=backend /app/node_modules ./node_modules
COPY --from=frontend /app/frontend/dist ./frontend/dist

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "backend/dist/main.js"]
