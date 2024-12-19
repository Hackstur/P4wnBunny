#!/bin/bash

function RUN() {
   local os=$1
   shift

   [[ -z "$os" || -z "$*" ]] && exit 1 # Both OS and Command parameter must be set

   case "$os" in
      WIN)
         QUACK GUI r
         QUACK DELAY 1200
         QUACK STRING "$@"
         QUACK DELAY 1000
         QUACK ENTER
         ;;
      OSX)
         QUACK GUI SPACE
         QUACK DELAY 1200
         QUACK STRING "$@"
         QUACK DELAY 500
         QUACK ENTER
         ;;
      UNITY)
         QUACK ALT F2
         QUACK DELAY 1600
         QUACK STRING "$@"
         QUACK DELAY 500
         QUACK ENTER
         ;;
      LINUX)
         QUACK ALT F2
         QUACK DELAY 1600
         QUACK STRING "$@"
         QUACK DELAY 500
         QUACK ENTER
         ;;
      *)
         # OS parameter must be one of the above
         exit 1
         ;;
   esac
}
export -f RUN