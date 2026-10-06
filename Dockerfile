
FROM  node:22.23.3-alpine3.24 as dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile


FROM  node:22.23.3-alpine3.24 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

FROM  node:22.23.3-alpine3.24 as prod-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile


FROM  node:22.23.3-alpine3.24 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]









