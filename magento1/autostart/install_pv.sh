#!/usr/bin/env bash

# Verify if pv command exists
if ! command -v pv &> /dev/null
then
    echo "pv command could not be found but it is installing, wait..."

    # Adjust repositories first (only for magento1)
    sudo sed -i -e 's/deb.debian.org/archive.debian.org/g' \
        -e 's|security.debian.org|archive.debian.org/|g' \
        -e '/stretch-updates/d' /etc/apt/sources.list

    # Update apt
    sudo apt update

    # Install pv on startup
    sudo apt install pv -y
fi
