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
else
    echo "GitHub Auto Deployer is not installed, Execute `install.sh` to install it.";
    exit;
fi &&


cd $SCRIPT_DIR &&
cp start.sh $DESTINATION_DIR &&
cp index.js $DESTINATION_DIR &&
cp yarn.lock $DESTINATION_DIR &&
cp index.html $DESTINATION_DIR &&
cp package.json $DESTINATION_DIR &&

cd $DESTINATION_DIR &&

yarn install &&
yarn global add pm2 &&

echo "**************Update completed**************";