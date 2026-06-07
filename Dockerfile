# ── 1단계: 의존성 설치 ──
FROM node:20-slim AS deps
WORKDIR /app

# package 파일 먼저 복사 (의존성 캐시 활용)
COPY package*.json ./
RUN npm ci --omit=dev          # 운영용 의존성만 설치 (devDependencies 제외)

# ── 2단계: 실행 ──
FROM node:20-slim
WORKDIR /app

# 보안: root 대신 기본 제공되는 node 사용자로 실행
COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
USER node
CMD ["node", "index.js"]       # 실제 진입 파일명으로 교체 (예: app.js, server.js)
