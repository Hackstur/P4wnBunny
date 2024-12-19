#!/bin/bash

function GET() {
  case "$1" in
    TARGET_IP)
      #export TARGET_IP=$(cat /tmp/dnsmasq_usbeth.leases | cut -d " " -f4)
      export TARGET_IP=$(cat /tmp/dnsmasq_usbeth.leases | cut -d " " -f3)
      _LOGGER INFO "GET TARGET_IP: $TARGET_IP"
      ;;
    TARGET_HOSTNAME)
      export TARGET_HOSTNAME=$(cat /tmp/dnsmasq_usbeth.leases | cut -d " " -f4)
      _LOGGER INFO "GET TARGET_HOSTNAME: $TARGET_HOSTNAME"
      ;;
    HOST_IP)
      export HOST_IP=$(ifconfig usbeth | awk '$1=="inet"{print $2}')
      _LOGGER INFO "GET TARGET_IP: $HOST_IP"
      ;;
    SWITCH_POSITION)
      export SWITCH_POSITION="$_SWITCH_POSITION"
      _LOGGER INFO "GET TARGET_IP: $SWITCH_POSITION"
      ;;
    TARGET_OS)
      TARGET_IP=TARGET_IP=$(cat /tmp/dnsmasq_usbeth.leases | cut -d " " -f4)
      ScanForOs=$(nmap -Pn -O $TARGET_IP -p1 -v2)
      [[ $ScanForOS == *"Too many fingerprints"* ]] && ScanForOS=$(nmap -Pn -O $TARGET_IP --osscan-guess -v2)
      [[ "${ScanForOS,,}" == *"windows"* ]] && export TARGET_OS='WINDOWS' && return
      [[ "${ScanForOS,,}" == *"apple"* ]] && export TARGET_OS='MACOS' && return
      [[ "${ScanForOS,,}" == *"linux"* ]] && export TARGET_OS='LINUX' && return
      export TARGET_OS='UNKNOWN'
	  ;;
	BB_LABEL)
	  export BB_LABEL="P4wnBunny"
    _LOGGER INFO "GET BB_LABEL: $BB_LABEL"
	  ;;
  esac
}

export -f GET
