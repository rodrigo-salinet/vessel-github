#!/usr/bin/env bash

# Configure Git2bis Username
git config --global user.name $GIT2BIS_USERNAME

# Configure Git2bis User Email
git config --global user.email $GIT2BIS_USEREMAIL

# Configure Git2bis Token
composer config --global gitlab-token.git2bis.com.br $GIT2BIS_TOKEN
