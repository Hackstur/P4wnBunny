#!/bin/bash

function DEBUG() {
    session=$1
    message=$2

    timestamp () {
        echo "$(date +"%Y-%m-%d_%H-%M-%S")"
    }

    mkdir -p /root/udisk/debug/
    debug_file="/root/udisk/debug/${session}.txt"
    [[ -f "${debug_file}" ]] || echo "$(timestamp): DEBUG STARTED" >> "${debug_file}"
    echo "$(timestamp): ${message}" >> ${debug_file}
}

export -f DEBUG