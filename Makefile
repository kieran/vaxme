.ONESHELL:
SHELL = /bin/bash

NODE_ENV ?= development
PORT ?= 3000

include .env.${NODE_ENV}

.PHONY: nvm install clean run dist start_mongo stop_mongo seed_mongo docker_run

node_modules/:
	@npm i

install: node_modules/

clean:
	@rm -rf ./node_modules

run: install
	set -m
	npm run serve &
	npm run api
	fg %1

api: install
	@node server/index.js

dist: install
	@npm run dist

#
# Docker stuff
#
start_mongo:
	mongod --fork --logpath /mongodb.log

stop_mongo:
	mongod --shutdown

seed_mongo:
	mongo --host ${MONGO_URL} --eval "db.postal_codes.drop()"

	@cat ./data/postal_codes.json | \
	jq --compact-output '[ .features[] | select(.type == "Feature") | { geometry, properties: { postal_code: .properties.CFSAUID, province_name: .properties.PRNAME } } ]' | \
	mongoimport --db vaxme -c postal_codes --jsonArray

	# TODO: fix index creation
	mongo --host ${MONGO_URL} --eval 'db.postal_codes.createIndex({ geometry: "2dsphere" })'

docker_build:
	docker image build -t vaxme:1.0 .

docker_start:
	docker run -it --publish 3000:${PORT} vaxme:1.0

# starts mongo as a background process, returning express to the foreground
# needs .ONESHELL directive & bash
docker_run:
	set -m
	node server/index.js &
	mongod --fork --logpath /mongodb.log
	fg %1


#
# GCP Deploy (Google Cloud Run)
#
# build & deploy to google cloud run
# - https://api-xbhormaofa-ue.a.run.app
#
gcloud_build:
	gcloud builds submit --tag gcr.io/vaxme/api

gcloud_deploy:
	gcloud run deploy --image gcr.io/vaxme/api --platform managed
