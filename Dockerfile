# 1단계: 빌드 환경
FROM node:18 AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

# 2단계: 실행 환경
FROM node:18-slim
WORKDIR /app

# 필요한 데이터만 쏙쏙 현재 스테이지로 뽑아서 가져오기
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
CMD ["yarn", "start"]