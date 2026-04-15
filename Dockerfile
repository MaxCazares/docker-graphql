
FROM node:18.13-alpine3.17 as dev-deps
WORKDIR /app
COPY package.json package.json
RUN npm install


FROM node:18.13-alpine3.17 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN npm run test
RUN npm run build

FROM node:18.13-alpine3.17 as prod-deps
WORKDIR /app
COPY package.json package.json
RUN npm install --production


FROM node:18.13-alpine3.17 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]









