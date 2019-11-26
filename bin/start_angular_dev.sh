#!/usr/bin/env sh

env | sort

cd client_spa
npm install
npm prune
npm start
