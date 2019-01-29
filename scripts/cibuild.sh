#!/usr/bin/env bash

echo 'Running cibuild script'

echo $GITHUB_REF > BRANCH
echo $GITHUB_ACTOR > DEPLOYER
echo $GITHUB_SHA > VERSION
