#!/bin/bash

# Text colors
red=`tput setaf 1`;
green=`tput setaf 2`;
reset=`tput sgr0`;

APP_DIR=~/.github-auto-deployer;

if [ -d $APP_DIR ]
then
    rm -r $APP_DIR &&
    echo "${green}GitHub Auto Deployer uninstalled successfully.${reset}";
else
    echo "GitHub Auto Deployer is not installed.";
fi;