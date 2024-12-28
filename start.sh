#!/bin/bash

# Get start script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

# App dir is same as start script dir
APP_DIR=$SCRIPT_DIR;

APP_CONF_FILE_PATH=$APP_DIR/app.conf;

# Default configurations
PORT=6767;
MY_SECRET=;
APP_NAME=github-auto-deployer;
APP_ENTRY_POINT=$APP_DIR/index.js;
DEPLOYMENT_FILE=$APP_DIR/deployment.yml;

# Load custom configurations if there's any
. $APP_CONF_FILE_PATH

# Start script(Do not edit it)
PORT=$PORT \
MY_SECRET=$MY_SECRET \
APP_DIR=$APP_DIR \
DEPLOYMENT_FILE=$DEPLOYMENT_FILE \
pm2 --name $APP_NAME \
start node -- $APP_ENTRY_POINT;