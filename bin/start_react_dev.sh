#!/usr/bin/env sh

env | sort

cd client
npm install
npm prune

npm run build:dev:client
