#!/bin/bash

APP_DIR=~/.github-auto-deployer;

if [ -d $APP_DIR ]
then
    rm -r $APP_DIR &&
    echo "Uninstalled successfully.";
else
    echo "GitHub Auto Deployer is not installed.";
fi;