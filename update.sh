#!/bin/bash

# Text colors
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

# Get update script dir
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )";

# App dir is same as update script dir
APP_DIR=$SCRIPT_DIR;

echo -n "Are you sure you want to update GitHub Auto Deployer? [Y/n]  ";
read response;

if [ $response = "Y" ] || [ $response = "y" ]
then
    echo "Downloading changes...";
    git pull origin $(git branch --show-current)
else
    exit;
fi &&

echo "Installing changes...";
. $APP_DIR/install.sh &&
echo "${green}GitHub Auto Deployer is successfully updated.${reset}";