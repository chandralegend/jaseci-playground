#!/bin/bash
docker pull jaseci/jaseci
cd jaseci-playground
pm2-runtime --name 'jaseci-playground' index.js
