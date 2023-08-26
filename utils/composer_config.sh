#!/usr/bin/env bash

# Configure Github Username
git config --global user.name $GITHUB_USERNAME

# Configure Github User Email
git config --global user.email $GITHUB_USEREMAIL

# Configure Github Token
composer config --global github-token.github.com $GITHUB_TOKEN
