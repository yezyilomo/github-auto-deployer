#!/bin/bash

# Get update script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
DESTINATION_DIR=~/.github-auto-deployer;


echo -n "Are you sure you want to update GitHub Auto Deployer? [Y/n]  ";
read response;

if [ $response = "Y" ] || [ $response = "y" ]
then
    echo "Downloading changes...";
    git pull origin master
else
    exit;
fi &&


if [ -d $DESTINATION_DIR ]
then
    echo "Installing changes...";
    APP_CONF=`cat $DESTINATION_DIR/app.conf`;
    DEPLOYMENT_SCRIPTS=`cat $DESTINATION_DIR/deployment.yaml`;
    rm -r $DESTINATION_DIR;
    . $SCRIPT_DIR/install.sh;
    "$APP_CONF" > $DESTINATION_DIR/app.conf;
    "$DEPLOYMENT_SCRIPTS" > $DESTINATION_DIR/deployment.yml;
else
    echo "GitHub Auto Deployer is not installed, Execute `install.sh` to install it.";
    exit;
fi;