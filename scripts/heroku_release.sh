#!/bin/bash -e

function usage {
    echo "Usage: $0 app_name api_key"
    echo
    echo 'You must run this in the context of your git repo.'
}

THIS_SCRIPT=$(readlink -f $0)
THIS_DIR=$(dirname ${THIS_SCRIPT})
HEROKU_APP_NAME=$1
HEROKU_API_KEY=$2

function check_command_line {
    if [ "${HEROKU_APP_NAME}" = "" ] ; then
        usage
        exit 1
    fi
}

function enable_shell_echo {
    set -x
}

function deploy_code_to_heroku {
    if [ "" != "$(git remote |grep -e '^heroku$')" ]; then
        git remote rm heroku
    fi

    git remote add heroku https://heroku:${HEROKU_API_KEY}@git.heroku.com/${HEROKU_APP_NAME}.git
    git push -f heroku HEAD:refs/heads/master
}

check_command_line
enable_shell_echo
deploy_code_to_heroku
