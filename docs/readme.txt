######################################################################################
                 ______ _____                  ______                          
     (\___/)    |   __ \  |  |.--.--.--.-----.|   __ \.--.--.-----.-----.--.--.
     (=^_^=)    |    __/__    |  |  |  |     ||   __ <|  |  |     |     |  |  |
     (")_(")    |___|     |__||________|__|__||______/|_____|__|__|__|__|___  |
                                                                        |_____|
P4wnBunny v0.0.1 by Hackstur (Off-Brand DuckyScript port)
Inspired by:
    - Hak5 Bash Bunny                       https://github.com/hak5/bashbunny-payloads
    - MaMe82 P4wnP1 A.L.O.A.                 https://github.com/RoganDawes/P4wnP1_aloa

                     USB Attack/Automation Platform with Wifi & Bluetooth capabilities
######################################################################################

This is a try to port BashBunny payloads without effort to our beloved P4wnP1 ALOA.
Also add some useful (i think) tools.


The road so far:
  (x) Port basic DuckyScript commands (2 ways).
        |- add in /etc/profile for system integration (careful!)
        |- import p4wnbunny.sh on your payload (like bash import)
  (x) Port basic BashBunny commands.
        |- TO-DO: By now infill files to image its tricky,  better do it before mount.


TO-DO:
  ( ) Installer script
  ( ) P4wnBunny payload library
  ( ) P4wnBunny system & payload workflow
        |- Infill at startup
        |- Exfill at finish
        |- Arming mode
  ( ) Run Scripts from webpage
  ( ) Improve Ducky commands ideas and extensions:
        |- BTH_ETHERNET
        |- WAIT_FOR_XXX
        |- EXFIL / INFIL / SYNC
  ( ) SharkJack script



Mass-Storage Directory Structure (p4wnbunny.bin)            Default Settings
--------------------------------------------------------    --------------------------
.
 |- docs/           - Documentation, books & cheatsheets    Username: root
 |- loot/           - Where payloads store logs and data    Password: toor
 |- scripts/        - P4wnP1 bash scripts repository        Hostname:
 |- HIDScripts/     - P4wnP1 HIDScripts repository
 |- duckyscripts/   - DuckyScripts repository               IP Address: 
 |- Keymaps/        - P4wnP1 HID language keymaps           USB: 172.16.0.1  
                                                            RNDIS: 172.24.0.1
                                                            BETH: 172.26.0.1



System Directory Structure 
--------------------------------------------------------
/usr/local/P4wnP1/      - P4wnP1 ALOA folder. 
/root/udisk/            - Lnks to other folders:
                          |-/usr/local/P4wnP1/
                            |- docs/
                            |- loot/
                            |- scripts/
                            |- HIDScripts/
                            |- duckyscripts/
                            |- keymaps/



Updating Workflow:
--------------------------------------------------------
Hak5 BashBunny has "arming mode". Im not implemented it.


Instead of that, i have some not implemented ideas...:D



Bunny Script Builtin Commands                                        Ducky Script
-------------------------------------------------------------        -----------------
ATTACKMODE  Specifies the USB devices to emulate.                    REM / REM_BLOCK
            Accept combinatios of simultaneus:                       DELAY
              - SERIAL                                               STRING / STRINGLN
              - RAW                                                  SPACE
              - ECM_ETHERNET                                         WINDOWS / GUI
              - RNDIS_ETHERNET                                       MENU / APP 
              - STORAGE                                              SHIFT
              - RO_STORAGE                                           ALT
              - HID (Alias for HID_KEYBOARD)                         CONTROL / CTRL
              - HID_MOUSE                                            UPARROW / UP
              - OFF (Disable all USB)                                DOWNARROW / DOWN
                                                                     LEFTARROW / LEFT
LED         Control the Green LED. Accepts blink pattern or          RIGHTARROW / RIGHT
            predefined payload state.                                PAUSE / BREAK
            See detail from LED section.                             DELETE
                                                                     END
QUACK       Injects specified keystrokes via Ducky Script            ESCAPE / ESC
            Accepts file relative to /payloads/ path                 HOME
            Accepts inline Ducky Script                              INSERT
                                                                     PAGEUP / PAGEDOWN
Q           Alias for QUACK                                          PRINTSCREEN
                                                                     SPACE
        Example:                                                     TAB
                                                                     NUMLOCK
        QUACK helloworld.txt  Inject keystrokes from file            SCROLLOCK
        Q STRING Hello World  Inject keystrokes from DuckyScript     CAPSLOCK
                                                                     F1....F12
 
DUCKY_LANG  Sets keystroke injection language
            Also works as a variable:
            DUCKY_LANG=es
            DUCKY_LANG es



Bunny Script Environment Variables
-------------------------------------------------------------

$TARGET_IP        IP Address of the computer received by the
                  P4wnP1 DHCP Server.

$TARGET_HOSTNAME  Host name of the computer on the P4wnP1
                  Network.

$HOST_IP          IP Address of the P4wnP1

$SWITCH_POSITION  pffff.... we dont need that...

$BB_LABEL         Volume name of the image.bin when mounted.



Bash Bunny Extensions
--------------------------------------------------------------------------------------

RUN               Simplifies command execution for HID attacks.

DUCKY_LANG        Specifies HID injection language for QUACK commands

REQUIRETOOL       Check if a tool is installed. Exits with LED FAIL if not.

GET               Returns environment variable

DEBUG             Show in prompt & Save payload log file in debug folder





Connecting to P4wnP1
--------------------------------------------------------------------------------------





Example payload Structure & good practics
--------------------------------------------------------------------------------------



Share Internet Connection with P4wnP1 from Windows/Linux
--------------------------------------------------------------------------------------



ATTACKMODE Command
--------------------------------------------------------------------------------------



LED Command
--------------------------------------------------------------------------------------