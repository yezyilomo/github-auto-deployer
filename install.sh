#!/bin/bash

# Text colors
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

# Get install script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
APP_DIR=~/.github-auto-deployer;

if [ -d $APP_DIR ]
then
    echo -n "Looks like GitHub Auto Deployer is already installed in the directory '$APP_DIR'. Are you sure you want to delete it and re-install? [Y/n]  ";
    read response;
    
    if [ $response = "Y" ] || [ $response = "y" ]
    then
        rm -r $APP_DIR;
    else
        exit;
    fi;
fi;


mkdir $APP_DIR &&

cd $SCRIPT_DIR &&
cp app.conf $APP_DIR &&
cp start.sh $APP_DIR &&
cp index.js $APP_DIR &&
cp yarn.lock $APP_DIR &&
cp index.html $APP_DIR &&
cp package.json $APP_DIR &&
cp deployment.yml $APP_DIR &&

cd $APP_DIR &&

yarn install &&
yarn global add pm2 &&

echo "${green}GitHub Auto Deployer is successfully installed on '$APP_DIR' directory.${reset}"