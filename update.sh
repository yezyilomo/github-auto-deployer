#!/bin/bash

# Text colors
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

# Get update script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
APP_DIR=~/.github-auto-deployer;


echo -n "Are you sure you want to update GitHub Auto Deployer? [Y/n]  ";
read response;

if [ $response = "Y" ] || [ $response = "y" ]
then
    echo "Downloading changes...";
    git pull origin master
else
    exit;
fi &&


if [ -d $APP_DIR ]
then
    echo "Installing changes...";
    APP_CONF=`cat $APP_DIR/app.conf` &&
    DEPLOYMENT_SCRIPTS=`cat $APP_DIR/deployment.yml` &&
    rm -r $APP_DIR &&
    . $SCRIPT_DIR/install.sh &&
    echo "$APP_CONF" > $APP_DIR/app.conf &&
    echo "$DEPLOYMENT_SCRIPTS" > $APP_DIR/deployment.yml &&
    echo "${green}GitHub Auto Deployer is successfully updated.${reset}";
else
    echo "GitHub Auto Deployer is not installed, Run `install.sh` to install it.";
    exit;
fi;