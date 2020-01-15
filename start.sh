#!/bin/bash
MY_SECRET=<Your Webhook Secret> \
CONF_FILE=<Your Deployment Config File> \  # like ./deployment.yaml 
pm2 --name github-auto-deployer \  # You can name it however you like
start node -- ./index.js  # Entry point