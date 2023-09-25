#!/usr/bin/env bash

# Verify if pv command exists
if ! command -v pv &> /dev/null
then
    echo "pv command could not be found but it is installing, wait..."

    # Update apt
    sudo apt update

    # Install pv on startup
    sudo apt install -y pv
fi
