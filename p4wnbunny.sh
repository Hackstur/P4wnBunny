#!/bin/bash

################################################################################################
#              ______ _____                  ______                          
#   (\___/)   |   __ \  |  |.--.--.--.-----.|   __ \.--.--.-----.-----.--.--.
#   (=^_^=)   |    __/__    |  |  |  |     ||   __ <|  |  |     |     |  |  |
#   (")_(")   |___|     |__||________|__|__||______/|_____|__|__|__|__|___  |
#                                                                     |_____|
# ----------------------------------------------------------------------------------------------
#  Author:    Hackstur
#  Version:   0.0.1 (Beta)
#  Website:   https://github.com/Hackstur/P4wnBunny
#  Description:
#     POC of DuckyScript/RubberDucky/BashBunny payloads interpreter for P4wnP1.
#       
#  Userguide:
#     You can use this script in 2ways by now (im think about a third one.. but not usable yet)
#           1) Import in your payload at start like "source p4wnbunny.sh"
#           2) Load into /etc/environment to use without import (be carefully)
#
#  Inspired by:
#     Hak5 Bashbunny: https://hak5.org/products/bash-bunny
#     P4wnP1 A.L.O.A: https://github.com/RoganDawes/P4wnP1_aloa
#
# ----------------------------------------------------------------------------------------------
# License:   MIT License
################################################################################################
# BANNER
echo "
######################################################################################
                 ______ _____                  ______                          
     (\___/)    |   __ \  |  |.--.--.--.-----.|   __ \.--.--.-----.-----.--.--.
     (=^_^=)    |    __/__    |  |  |  |     ||   __ <|  |  |     |     |  |  |
     (\")_(\")    |___|     |__||________|__|__||______/|_____|__|__|__|__|___  |
                                                                        |_____|
P4wnBunny v0.0.1 by Hackstur
Inspired by:
    - Hak5 Bash Bunny                       https://github.com/hak5/bashbunny-payloads
    - MaMe82 P4wnP1 A.L.O.A.                 https://github.com/RoganDawes/P4wnP1_aloa
                                                        USB Attack/Automation Platform
######################################################################################
"
#region ---- [ P4WNBUNNY VARIABLES ]
_configfile_path="/root/p4wnbunny/config.txt"
_extensions_path="/root/p4wnbunny/extensions/"
_bunny_image="p4wnbunny.bin"

# HW
_SWITCH_POSITION="switch1"

#endregion


#region ---- [ P4WNBUNNY FRAMEWORK ]
function _LOGGER() {
    local level=$1
    local message=$2

    # Colores ANSI
    local RESET="\e[0m"
    local RED="\e[31m"
    local GREEN="\e[32m"
    local YELLOW="\e[33m"
    local MAGENTA="\e[35m"

    # Niveles y colores
    case "$level" in
        INFO)
            echo -e "${GREEN}[+]${RESET} $message"
            ;;
        WARNING)
            echo -e "${YELLOW}[!]${RESET} $message"
            ;;
        ERROR)
            echo -e "${RED}[E]${RESET} $message"
            ;;
        DEBUG)
            echo -e "${MAGENTA}[*]${RESET} $message"
            ;;
        *)
            echo -e "${RESET}[@] $message"
            ;;
    esac
}
export -f _LOGGER

function _import_extensions() {
    local dir="${_extensions_path}"
    if [ -d "$dir" ]; then
        for file in "$dir"/*.sh; do
            if [ -f "$file" ]; then
                
                source "$file"
            fi
        done
        _LOGGER INFO "EXTENSIONS: LOADED"
    else
        _LOGGER INFO "EXTENSIONS: $dir does not exist."
    fi
}
_import_extensions


# helper function to kills all tools process
function _FINISH() {
    pkill -f gohttp >/dev/null
    pkill -f Responder >/dev/null
    _LOGGER INFO "P4WNBUNNY: FINISH!"
}
export -f _FINISH

#endregion


#region ---- [ OS REWORK & HELPER COMMANDS ]

# python runs python2
python() {
    python2 $*
}

#endregion


#region ---- [ INTERNAL VARIABLES ]

# ATTACKMODE
export _CURRENT_PID='eval echo $(P4wnP1_cli usb get | grep -i "PID:" | awk "{print \$2}")'
export _CURRENT_VID='eval echo $(P4wnP1_cli usb get | grep -i "VID:" | awk "{print \$2}")'

_CURRENT_ATTACKMODE=false
_SAVED_ATTACKMODE=false

# RANDOM
export _RANDOM_INT='eval echo $((RANDOM % (_RANDOM_MAX - _RANDOM_MIN + 1) + _RANDOM_MIN))'
export _RANDOM_MIN=42
export _RANDOM_MAX=1337
export _RANDOM_SEED=FALSE
export _RANDOM_LOWER_LETTER_KEYCODE='eval echo ${_LOWER_LETTERS:RANDOM%${#_LOWERC_LETTERS}:1}'
export _LOWER_LETTERS="abcdefghijklmnopqrstuvwxyz"
export _RANDOM_UPPER_LETTER_KEYCODE='eval echo ${_UPPER_LETTERS:RANDOM%${#_UPPER_LETTERS}:1}'
export _UPPER_LETTERS="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
export _RANDOM_LETTER_KEYCODE='eval echo ${_LETTERS:RANDOM%${#_LETTERS}:1}'
export _LETTERS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
export _RANDOM_NUMBER_KEYCODE='eval echo ${_NUMBERS:RANDOM%${#_NUMBERS}:1}'
export _NUMBERS="0123456789"
export _RANDOM_SPECIAL_KEYCODE='eval echo ${_SPECIALS:RANDOM%${#_SPECIALS}:1}'
export _SPECIALS="!@#$%^&*()"
export _RANDOM_CHAR_KEYCODE='eval echo ${_CHARS:RANDOM%${#_CHARS}:1}'
export _CHARS="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"

# JITTER
export _JITTER_ENABLED=true
function JITTER_MAX() {
  [[ -z "$1" ]] && exit 1 # parameter must be set
  #P4wnP1_cli hid run -c "layout('$1');" >/dev/null
  _LOGGER INFO "SET JITTER TO $1"
  export JITTER_MAX="$1"
}
export -f JITTER_MAX

# LOCK KEYS
_CAPSLOCK_ON=FALSE
_NUMLOCK_ON=FALSE
_SCROLLLOCK_ON=FALSE
_SAVED_CAPSLOCK_ON=FALSE
_SAVED_NUMLOCK_ON=FALSE
_SAVED_SCROLLLOCK_ON=FALSE
_RECEIVED_HOST_LOCK_LED_REPLY=FALSE

# STORAGE
_STORAGE_ACTIVITY_TIMEOUT=1000

# EXFILTRATION
_EXFIL_MODE_ENABLED=FALSE

# OS DETECT
_HOST_CONFIGURATION_REQUEST_COUNT=FALSE
_OS=false


DEFAULT_DELAY=500
DEFAULT_CHAR_DELAY=20


#endregion


#region ---- [ BASE BUNNY COMMANDS ]

SAVE_ATTACKMODE() {
    _LOGGER INFO "ATTACKMODE: SAVED"
}

RESTORE_ATTACKMODE() {
    _LOGGER INFO "ATTACKMODE: RESTORED"
}


function ATTACKMODE() {
    local options=""
    local need_change=false
    local hid_enabled=false
    local current_status
    current_status=$(P4wnP1_cli usb get)

    check_status() {
        local key=$1
        local value=$2
        # Comprobamos si la clave tiene el valor correcto
        if echo "$current_status" | grep -qiE "^\s*$key\s*[:]\s*$value\s*$"; then
            return 0
        else
            return 1
        fi
    }



    # Verificamos todos los modos solicitados y agregamos al comando todos los modos.
    for mode in "$@"; do
        case "$mode" in
            HID)
                options="$options --hid-keyboard"
                hid_enabled=true
                check_status "HID Keyboard" "true" || need_change=true
                ;;
            STORAGE)
                options="$options --ums --ums-file bashbunny.bin"
                check_status "Mass Storage" "true" || need_change=true
                ;;
            RNDIS_ETHERNET)
                options="$options --rndis"
                check_status "RNDIS" "true" || need_change=true
                ;;
            CDC_ECM)
                options="$options --cdc-ecm"
                check_status "CDC ECM" "true" || need_change=true
                ;;
            SERIAL)
                options="$options --serial"
                check_status "Serial" "true" || need_change=true
                ;;
            VID_*)
                vid="${mode#VID_}"
                options="$options --vid $vid"
                need_change=true
                ;;
            PID_*)
                pid="${mode#PID_}"
                options="$options --pid $pid"
                need_change=true
                ;;
            MAN_*)
                man="${mode#MAN_}"
                options="$options --manufacturer $man"
                need_change=true
                ;;
            *)
                _LOGGER WARNING "ATTACKMODE: Unknown mode $mode"
                ;;
        esac
    done

    # Si se necesita hacer algún cambio, aplicamos todos los modos solicitados
    if [ "$need_change" = true ]; then
        _LOGGER INFO "ATTACKMODE: Applying changes with options:$options"
        P4wnP1_cli usb set $options >/dev/null
        _CURRENT_ATTACKMODE=$*
        sleep 7
    else
        _LOGGER INFO "ATTACKMODE: No changes needed, all options are already active"
        _CURRENT_ATTACKMODE=$*
    fi
    _LOGGER INFO "ATTACKMODE: $_CURRENT_ATTACKMODE"
    if [ "$hid_enabled" = true ]; then
        _LOGGER INFO "APPLY LANG $DUCKY_LANG"
        P4wnP1_cli hid run -c "layout('$DUCKY_LANG');" >/dev/null
        
        if [ "$_JITTER_ENABLED" = true ]; then
            _LOGGER INFO "APPLY JITTER $JITTER_MAX"
            P4wnP1_cli hid run -c "typingSpeed(0,$JITTER_MAX);" >/dev/null
        fi
    fi

}
export -f ATTACKMODE

function LED() {
    local state=$1
    _LOGGER INFO "LED: $1"
    case "$state" in
        OFF)
            # OFF = blink 0
            P4wnP1_cli led -b 0 >/dev/null
            ;;
        SETUP) 
            # SETUP = Fixed led
            P4wnP1_cli led -b 255 >/dev/null
            ;;
        ATTACK)
            # ATTACK = blink 10
            P4wnP1_cli led -b 10 >/dev/null
            ;;
        FINISH)
            # FINISH = blink 0
            P4wnP1_cli led -b 0 >/dev/null

            # helper finish commands
            _FINISH
            ;;
        STAGE1)
            # STAGE1 = blink 1
            P4wnP1_cli led -b 1 >/dev/null
            ;;
        STAGE2)
            # STAGE1 = blink 2
            P4wnP1_cli led -b 1 >/dev/null
            ;;
        CLEANUP)
            # STAGE1 = blink 2
            P4wnP1_cli led -b 5 >/dev/null
            ;;
        *)
            _LOGGER WARNING "Estado LED no reconocido: $state"
            ;;
    esac
}
export -f LED

function LED_OFF() { LED OFF; }; export -f LED_OFF
function LED_R() { LED R; }; export -f LED_R
function LED_G() { LED G; }; export -f LED_G

function Q() { QUACK $*; }; export -f Q

function QUACK() {
    local input="$1" 
    if [ -z "$input" ]; then
        _LOGGER ERROR "ERROR: QUACK needs arguments."
        return 1
    fi

    if [ -f "$input" ]; then
        _LOGGER ERROR "WIP launchid duckyscript file: $input"
    else
        _LOGGER INFO "QUACK: $*"
        case "$input" in
            STRING*) 
                shift
                STRING $*
                ;;
            ALT*) 
                shift
                P4wnP1_cli hid run -c "press('ALT $*');" >/dev/null
                ;;
            LEFTARROW*)
                P4wnP1_cli hid run -c "press('LEFT');" >/dev/null
                ;;
            LEFT*)
                P4wnP1_cli hid run -c "press('LEFT');" >/dev/null
                ;;
            ENTER*)
                P4wnP1_cli hid run -c "press('ENTER');" >/dev/null
                ;;
            DELAY*)
                shift
                DELAY $*
                ;;
            GUI*)
                shift
                GUI $*
                ;;
            CTRL-SHIFT*)
                shift
                CTRL-SHIFT $*
                ;;
            CONTROL*)
                shift
                CONTROL $*
                ;;
            *) 
                _LOGGER WARNING "Not command found: $input"
                ;;
        esac
    fi
}
export -f QUACK
#endregion


#region ---- [ COMMENTS ]
function REM() { :; }; export -f REM

function REMBLOCK() {
    if [ "$#" -gt 0 ]; then
        :;
    fi

    while read -r line; do
        if [[ "$line" == "END_REM" ]]; then
            break
        fi
        :;
    done
}
export -f REMBLOCK

#endregion 


#region ---- [ KEYSTROKE INJECTION ]
function STRING() { 
    local text="$*"
    text=${text//\\/\\\\}
    text=${text//\'/\\\'}
    #text=${text//\\\\\"/\"}
    _LOGGER INFO "STRING: $text"
    P4wnP1_cli hid run -c "type('$text');" >/dev/null
}
export -f STRING

function STRINGLN() {
    _LOGGER_INFO "[+] STRINGLN: $*"
    if [ "$#" -gt 0 ]; then
        P4wnP1_cli hid run -c "type('$*\n');" >/dev/null
    fi

    while read -r line; do
        if [[ "$line" == "END_STRINGLN" ]]; then
            break
        fi
        echo "Inyectando: $line seguido de ENTER"
        echo -n "$line"
        echo ""
    done
}
export -f STRINGLN
#endregion


#region ---- [ CURSOR KEYS ]
function UP() { P4wnP1_cli hid run -c "press('UP'); "; }; export -f UP
function DOWN() { P4wnP1_cli hid run -c "press('DOWN'); "; }; export -f DOWN
function LEFT() { P4wnP1_cli hid run -c "press('LEFT'); "; }; export -f LEFT
function RIGHT() { P4wnP1_cli hid run -c "press('RIGHT'); "; }; export -f RIGHT

function UPARROW() { UP; }; export -f UPARROW
function DOWNARROW() { DOWN; }; export -f DOWNARROW
function LEFTARROW() { LEFT; }; export -f LEFTARROW
function RIGHTARROW() { RIGHT; }; export -f RIGHTARROW

function PAGEUP() { P4wnP1_cli hid run -c "press('PAGEUP'); "; }; export -f PAGEUP
function PAGEDOWN() { P4wnP1_cli hid run -c "press('PAGEDOWN'); "; }; export -f PAGEDOWN

function HOME() { P4wnP1_cli hid run -c "press('HOME'); "; }; export -f HOME
function END() { P4wnP1_cli hid run -c "press('END'); "; }; export -f END

function INSERT() { P4wnP1_cli hid run -c "press('INSERT'); "; }; export -f INSERT
function DELETE() { P4wnP1_cli hid run -c "press('DELETE'); "; }; export -f DELETE
function DEL() { P4wnP1_cli hid run -c "press('DEL'); "; }; export -f DEL
function BACKSPACE() { P4wnP1_cli hid run -c "press('BACKSPACE'); "; }; export -f BACKSPACE

function TAB() { P4wnP1_cli hid run -c "press('TAB'); "; }; export -f TAB
function SPACE() { P4wnP1_cli hid run -c "press('SPACE'); "; }; export -f SPACE

#endregion


#region ---- [ SYSTEM KEYS ]
function ENTER() { P4wnP1_cli hid run -c "press('ENTER');"; _LOGGER INFO "PRESS: ENTER"; }; export -f ENTER
function SCAPE() { P4wnP1_cli hid run -c "press('SCAPE');"; _LOGGER INFO "PRESS: SCAPE"; }; export -f SCAPE
function PAUSE() { P4wnP1_cli hid run -c "press('PAUSE');"; _LOGGER INFO "PRESS: PAUSE"; }; export -f PAUSE
function BREAK() { P4wnP1_cli hid run -c "press('BREAK');"; _LOGGER INFO "PRESS: BREAK"; }; export -f BREAK
function PRINTSCREEN() { P4wnP1_cli hid run -c "press('PRINTSCREEN');"; _LOGGER INFO "PRESS: PRINTSCREEN"; }; export -f PRINTSCREEN
function MENU() { P4wnP1_cli hid run -c "press('MENU');"; _LOGGER INFO "PRESS: MENU"; }; export -f MENU
function APP() { P4wnP1_cli hid run -c "press('APP');"; _LOGGER INFO "PRESS: APP"; }; export -f APP

function F1() { P4wnP1_cli hid run -c "press('F1');"; _LOGGER INFO "PRESS: F1"; }; export -f F1
function F2() { P4wnP1_cli hid run -c "press('F2');"; _LOGGER INFO "PRESS: F2"; }; export -f F2
function F3() { P4wnP1_cli hid run -c "press('F3');"; _LOGGER INFO "PRESS: F3"; }; export -f F3
function F4() { P4wnP1_cli hid run -c "press('F4');"; _LOGGER INFO "PRESS: F4"; }; export -f F4
function F5() { P4wnP1_cli hid run -c "press('F5');"; _LOGGER INFO "PRESS: F5"; }; export -f F5
function F6() { P4wnP1_cli hid run -c "press('F6');"; _LOGGER INFO "PRESS: F6"; }; export -f F6
function F7() { P4wnP1_cli hid run -c "press('F7');"; _LOGGER INFO "PRESS: F7"; }; export -f F7
function F8() { P4wnP1_cli hid run -c "press('F8');"; _LOGGER INFO "PRESS: F8"; }; export -f F8
function F9() { P4wnP1_cli hid run -c "press('F9');"; _LOGGER INFO "PRESS: F9"; }; export -f F9
function F10() { P4wnP1_cli hid run -c "press('F10');"; _LOGGER INFO "PRESS: F10"; }; export -f F10
function F11() { P4wnP1_cli hid run -c "press('F11');"; _LOGGER INFO "PRESS: F11"; }; export -f F11
function F12() { P4wnP1_cli hid run -c "press('F12');"; _LOGGER INFO "PRESS: F12"; }; export -f F12

#endregion


#region ---- [ MODIFIER KEYS ]
function WINDOWS() { GUI $*; }; export -f WINDOWS
function GUI() {
    _LOGGER INFO "PRESS: GUI $*"
    if [[ -z "$*" ]]; then
        P4wnP1_cli hid run -c "press('GUI');" >/dev/null
    else        
        P4wnP1_cli hid run -c "press('GUI $*');" >/dev/null
    fi
}
export -f GUI

function ALT() {
    _LOGGER INFO "PRESS: ALT $*"
    if [[ -z "$*" ]]; then
        P4wnP1_cli hid run -c "press('ALT');" >/dev/null
    else
        P4wnP1_cli hid run -c "press('ALT $*');" >/dev/null
    fi
}
export -f ALT

function CTRL-SHIFT() {
    _LOGGER INFO "PRESS: CTRL-SHIFT $*"
    if [[ -z "$*" ]]; then
        P4wnP1_cli hid run -c "press('CTRL SHIFT');" >/dev/null
    else
        P4wnP1_cli hid run -c "press('CTRL SHIFT $*');" >/dev/null
    fi
}
export -f CTRL-SHIFT

function CONTROL() {
    _LOGGER INFO "PRESS: CTRL $*"
    if [[ -z "$*" ]]; then
        P4wnP1_cli hid run -c "press('CTRL');" >/dev/null
    else
        P4wnP1_cli hid run -c "press('CTRL $*');" >/dev/null
    fi
}
export -f CONTROL
#endregion


#region ---- [ LOCK KEYS ]
function CAPSLOCK() { P4wnP1_cli hid run -c "press('CAPS');"; _LOGGER INFO "PRESS: CAPSLOCK"; }; export -f CAPSLOCK
function NUMLOCK() { P4wnP1_cli hid run -c "press('NUMLOCK');"; _LOGGER INFO "PRESS: NUMLOCK"; }; export -f NUMLOCK
function SCROLLOCK() { P4wnP1_cli hid run -c "press('SCROLLOCK');"; _LOGGER INFO "PRESS: SCROLLOCK"; }; export -f SCROLLOCK

#endregion


#region ---- [ DELAYS ]
function DELAY() {
    local ms=$1
    local seconds=$(echo "$ms / 1000" | awk '{print $1/1000}')
    _LOGGER INFO "DELAY: $seconds"
    sleep $seconds
}
export -f DELAY

DEFAULT_DELAY() { local ms=$1; local seconds=$(echo "$ms / 1000" | awk '{print $1/1000}');  DEFAULT_DELAY=$seconds; }

DEFAULT_CHAR_DELAY() { local ms=$1; local seconds=$(echo "$ms / 1000" | awk '{print $1/1000}'); DEFAULT_CHAR_DELAY=$seconds; }

#endregion


function PRESS() { P4wnP1_cli hid run -c "press('$*');"; _LOGGER INFO "PRESS: $*"; }; export -f PRESS


# ---- [ RUBBERDUCKY HW BUTTON ]
WAIT_FOR_BUTTON_PRESS() { :; }

BUTTON_DEF() { :; }

DISABLE_BUTTON() { :; }




# GET PAYLOAD INFO
#importing_file="$(realpath ${BASH_SOURCE[1]})"

#_LOGGER INFO "PAYLOAD: $importing_file"

# LOAD & RUN DEFAULT CONFIG
if [[ -f "$_configfile_path" ]]; then
    . "$_configfile_path"
    _LOGGER INFO "CONFIG: Loaded $_configfile_path"   
else
    _LOGGER ERROR "CONFIG: File doesnt exists '$_configfile_path'."
fi