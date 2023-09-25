#!/usr/bin/env bash

# Verify if compass command exists
if ! command -v compass &> /dev/null
then
    echo "compass command could not be found but installing, wait..."
    # Install compass on startup
    sudo gem install compass -f
fi
