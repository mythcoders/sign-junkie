#!/usr/bin/env bash

write_version() {
  if [ -z "$CI_COMMIT_TAG" ]; then
    echo "NO VERSION FOUND"
    echo "0.0.0" > VERSION
  else
    echo "VERSION FOUND"
    echo "$CI_COMMIT_TAG" > VERSION
  fi
}

write_branch() {
  echo "$CI_COMMIT_REF_NAME" > BRANCH
}

write_master_key() {
  echo "$RAILS_MASTER_KEY" > config/master.key
}