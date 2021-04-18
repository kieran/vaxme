FROM alpine:3.13.5

RUN apk add --update --no-cache \
  bash \
  npm \
  gzip \
  jq \
  make

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories
RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories

RUN apk update
RUN apk add mongodb mongodb-tools

RUN mkdir -p /data/db

COPY package.json package-lock.json ./
RUN npm i

COPY .env.* ./
COPY server server
COPY data data

COPY Makefile ./

RUN make start_mongo seed_mongo stop_mongo

CMD [ "make", "docker_run" ]
