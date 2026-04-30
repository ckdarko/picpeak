# ---- Build frontend ----
FROM node:20-alpine AS frontend
WORKDIR /app
COPY frontend ./frontend
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps
RUN npm run build --prefix frontend

# ---- Build backend ----
FROM node:20-alpine AS backend
WORKDIR /app
COPY backend ./backend
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

# ---- Final runtime image ----
FROM node:20-alpine
WORKDIR /app

# Copy backend
COPY --from=backend /app/backend ./backend
COPY --from=backend /app/node_modules ./node_modules

# Copy frontend build
COPY --from=frontend /app/frontend/dist ./frontend/dist

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "backend/dist/main.js"]
