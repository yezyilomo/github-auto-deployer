#!/bin/bash
MY_SECRET=<Your Webhook Secret>;
APP_NAME=github-auto-deployer;
APP_DIR=~/.github-auto-deployer;
APP_ENTRY_POINT=$APP_DIR/index.js;
DEPLOYMENT_FILE=$APP_DIR/deployment.yml;


# Start script(Do not edit it)
MY_SECRET=$MY_SECRET DEPLOYMENT_FILE=$DEPLOYMENT_FILE  pm2 --name $APP_NAME  start node -- $APP_ENTRY_POINT;