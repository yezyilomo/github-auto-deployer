#!/bin/bash
# Get install script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";
DESTINATION_DIR=~/.github-auto-deployer;

mkdir $DESTINATION_DIR &&

cd $SCRIPT_DIR &&
cp start.sh $DESTINATION_DIR &&
cp index.js $DESTINATION_DIR &&
cp yarn.lock $DESTINATION_DIR &&
cp index.html $DESTINATION_DIR &&
cp install.sh $DESTINATION_DIR &&
cp package.json $DESTINATION_DIR &&
cp deployment.yml $DESTINATION_DIR &&

cd $DESTINATION_DIR &&

yarn install &&
yarn global add pm2