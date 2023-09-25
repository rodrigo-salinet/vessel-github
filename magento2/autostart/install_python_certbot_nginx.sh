#!/usr/bin/env bash

# Verifying if python3-certbot-nginx is installed on container
PACKAGE_PYTHON3_CERTBOT_NGINX=$(apt -qq list python3-certbot-nginx)
if [ $PACKAGE_PYTHON3_CERTBOT_NGINX == "" ]; then
    # Installing python3-certbot-nginx package
    sudo apt-get install python3-certbot-nginx -y
fi
