#!/bin/bash

# Get install script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
APP_DIR=~/.github-auto-deployer;

if [ -d $APP_DIR ]
then
    echo -n "Directory $APP_DIR already exists. Are you sure you want to delete it and re-install? [Y/n]  ";
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
yarn global add pm2