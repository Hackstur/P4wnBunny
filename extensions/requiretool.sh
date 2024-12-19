#!/bin/bash

function REQUIRETOOL() {
  [[ -z "$1" ]] && exit 1 # parameter must be set

  if [ ! -d /tools/$1/ ]; then
    LED FAIL
    exit 1
  fi
}
export -f REQUIRETOOL
