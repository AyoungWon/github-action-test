FROM node:16.19.0-alpine3.16 as builder

RUN mkdir app
WORKDIR /app

COPY . .

RUN yarn install && yarn build

FROM node:16.19.0-alpine3.16
RUN mkdir app
WORKDIR /app

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/tsconfig.json ./
COPY --from=builder /app/src ./src

RUN yarn install --production

CMD ["yarn", "start:prod"]