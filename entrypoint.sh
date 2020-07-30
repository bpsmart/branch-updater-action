#!/bin/bash

set -e

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo -e "\e[31mGITHUB_TOKEN needs to be set in env. Exiting."
  exit 1
fi

REPO=$(jq -r '.repository.full_name' "${GITHUB_EVENT_PATH}")

# git setup
echo -e "\e[34mSetting up git configuration"
git config --global user.name "BPSmart Developer Bot"
git config --global user.email "dev.ci@bpsmart.ai"

BASE_BRANCH=$(echo ${GITHUB_REF##*/})
echo "Current branch is ${BASE_BRANCH}"

# create work directory
echo -e "\e[34mCreating temporary work directory in /tmp"
WORK_DIR=$(mktemp -d -p /tmp)
pushd "${WORK_DIR}" || exit 1

# clone repository
echo -e "\e[34mCloning ${BASE_BRANCH} of ${REPO} into ${WORK_DIR}"
git clone --depth=1 --branch="${BASE_BRANCH}" "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${REPO}" .

# make sure we are up to date
echo -e "\e[34mPulling latest changes"
git pull

echo "Success!"
