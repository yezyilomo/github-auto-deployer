#!/bin/bash
pm2 --name github-auto-deployer start node -- ./index.js CONF_FILE=./deployment.yml MY_SECRET=<Your Webhook Secret>