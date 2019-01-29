#!/usr/bin/env bash

echo 'Running cibuild script'

ENV['GITHUB_REF'] > BRANCH
ENV['GITHUB_ACTOR'] > DEPLOYER
ENV['GITHUB_SHA'] > VERSION

container:push --app $HEROKU_APP web
