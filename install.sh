#!/bin/bash

# Text colors
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

# Get install script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

# App dir is same as install script dir
APP_DIR=$SCRIPT_DIR;

APP_CONF_FILE_PATH=$APP_DIR/app.conf;
APP_DEPLOYMENT_FILE_PATH=$APP_DIR/deployment.yml;

APP_CONF='# Write your configurations here
MY_SECRET=<Put Your Webhook Secret Here>
# PORT=6767
';

APP_DEPLOYMENT='# Demo repositories deployment configuration
# Delete this and put your repositories deployment configuration here

repository_one:  # Repository Name(Should match the one on GitHub)
  - directory:  # Repository`s working directory
      - /path/to/repository_one/
  - get_changes:  # Commands to get new changes(git pull origin $current-branch is the default)
      - git pull origin main
  - script:  # script name to run(deployment.sh is the default)
      - deployment.sh


repository_two:  # Repository Name(Should match the one on GitHub)
  - directory:  # Repository/Working directory
      - /path/to/repository_two/
  - get_changes:  # Commands to get new changes(git pull origin $current-branch is the default)
      - git pull origin main
  - script:  # script name to run(deployment.sh is the default)
      - deployment.sh
';


if [ -f $APP_CONF_FILE_PATH ]
then
    echo -e "Configuration file found..";
else
    echo -e "Creating configuration file..";
    echo "$APP_CONF" > $APP_CONF_FILE_PATH;
fi;


if [ -f $APP_DEPLOYMENT_FILE_PATH ]
then
    echo -e "Deployment file found..";
else
    echo -e "Creating configuration file..";
    echo "$APP_DEPLOYMENT" > $APP_DEPLOYMENT_FILE_PATH;
fi;

cd $APP_DIR;
npm install;
npm install pm2 -g

echo "${green}GitHub Auto Deployer is successfully installed on '$APP_DIR' directory.${reset}"