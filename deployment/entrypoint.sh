#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
# http://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
set -e

# Define help message
function show_help() {
    echo """
Usage: docker run <imagename> COMMAND

Commands

server   : Start gunicorn in production mode
bash     : Start a bash shell
help     : Show this message
"""
}

# Run
case "$1" in
    server)
        npm start
    ;;
    bash)
        /bin/bash "${@:2}"
    ;;
    *)
        show_help
    ;;
esac
