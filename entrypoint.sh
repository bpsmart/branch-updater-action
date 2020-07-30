#!/bin/bash

set -e

# if [[ -z "${GITHUB_TOKEN}" ]]; then
#   echo -e "\e[31mGITHUB_TOKEN needs to be set in env. Exiting."
#   exit 1
# fi

# git setup
echo -e "\e[34mSetting up git configuration"
git config --global user.name "BPSmart Developer Bot"
git config --global user.email "dev.ci@bpsmart.ai"

branch=$(echo ${GITHUB_REF##*/})
echo "Current branch is ${branch}"

echo "Success!"
