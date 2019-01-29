#!/usr/bin/env bash

echo 'Running cibuild script'

echo $GITHUB_REF > BRANCH
echo $GITHUB_SHA > VERSION
echo "$(GITHUB_ACTOR)|$(date '+%m%d%y%H%M')" > DEPLOYER
