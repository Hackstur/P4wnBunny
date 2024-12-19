#!/bin/bash

function DUCKY_LANG() {
  [[ -z "$1" ]] && exit 1
  _LOGGER INFO "SET LANG TO $1"
  export DUCKY_LANG="$1"
}
export -f DUCKY_LANG
