# syntax=docker/dockerfile:1.7
# Next.js standalone image. Build GitHub Actions runner'ida `docker build` ichida bajariladi —
# serverda build YO'Q. Yakuniy image'da faqat .next/standalone (server.js + kerakli node_modules),
# .next/static va public bor: source, dev deps va kompilyator yo'q.
# Hammasi bitta base'da (alpine): native paketlar (sharp) build va runtime'da bir xil bo'ladi.

FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:22-alpine AS builder
WORKDIR /app
ENV NEXT_TELEMETRY_DISABLED=1
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# NEXT_PUBLIC_* build vaqtida client bundle ichiga yoziladi — runtime'da o'zgartirib bo'lmaydi.
# CI GitHub variable'dan beradi; bo'sh bo'lsa so'rovlar front domenining o'ziga ketadi
# (serverda nginx /dashboard/ va /mobile/ ni backend'ga yo'naltiradi).
ARG NEXT_PUBLIC_API_URL=""
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
RUN npm run build

FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    PORT=3000 \
    HOSTNAME=0.0.0.0

# root emas. .next ga yozish huquqi kerak (image optimization keshi).
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
COPY --from=builder --chown=node:node /app/public ./public
USER node

EXPOSE 3000
CMD ["node", "server.js"]
