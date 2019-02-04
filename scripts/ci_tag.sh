#!/usr/bin/env bash

echo 'Running ci_tag...'

BRANCH=$GITHUB_REF
VERSION=$GITHUB_SHA
DEPLOYER=$GITHUB_ACTOR
DEPLOY_TIME="$(date +%s)"

echo "Branch: $BRANCH"
echo "Version: $VERSION"
echo "Deployer: $DEPLOYER"
echo "Deploy Time: $DEPLOY_TIME"

echo $BRANCH > BRANCH
echo $VERSION > VERSION
echo $DEPLOYER > DEPLOYER
echo $DEPLOY_TIME > DEPLOY_TIME
