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
echo "Base branch is ${BASE_BRANCH}"

TARGET_BRANCH=$(if [[ "$BASE_BRANCH" == "master" ]]; then echo "qa"; elif [[ "$BASE_BRANCH" == "qa" ]]; then echo "dev"; else echo ""; fi)
echo "Target branch is ${TARGET_BRANCH}"

if [[ ${TARGET_BRANCH} == "" ]]; then
  echo -e "\e[33mNot targeting base branches"
  exit 0
fi

# create work directory
echo -e "\e[34mCreating temporary work directory in /tmp"
WORK_DIR=$(mktemp -d -p /tmp)
pushd "${WORK_DIR}" || exit 1

# clone repository
echo -e "\e[34mCloning ${BASE_BRANCH} of ${REPO} into ${WORK_DIR}"
git clone "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${REPO}" .

# make sure we are up to date
echo -e "\e[34mPulling latest changes"
git pull

# fetch all branches
echo -e "\e[34mFetching all branches"
git fetch

# checkout to target branch
echo -e "\e[34mChecking out to target branch"
git checkout "${TARGET_BRANCH}"

# rebase from base branch
echo -e "\e[34mRebasing from base branch"
git rebase

# commit changes
echo -e "\e[34mUploding changes"
git add .
git commit -m "Auto update from ${BASE_BRANCH} into ${TARGET_BRANCH}"
git push origin "${TARGET_BRANCH}"

echo "Success!"
