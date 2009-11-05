# Pool configuration
SRCPOOL=zbsrctest
DSTPOOL=zbdsttest
POOLSIZE=64M

LOGFILE=zbtest.log

# Command locations
ZPOOL=/usr/sbin/zpool
ZFS=/usr/sbin/zfs
DATE=/bin/date
ZETABACK=$PWD/../zetaback

# Colors
export RESET="$(     tput sgr0)"    # Reset all attributes
export BRIGHT="$(    tput bold)"    # Set “bright” attribute
export BLACK="$(     tput setaf 0)" # foreground to color #0 - black
export RED="$(       tput setaf 1)" # foreground to color #1 - red
export GREEN="$(     tput setaf 2)" # foreground to color #2 - green
export YELLOW="$(    tput setaf 3)" # foreground to color #3 - yellow
export BLUE="$(      tput setaf 4)" # foreground to color #4 - blue
export MAGENTA="$(   tput setaf 5)" # foreground to color #5 - magenta
export CYAN="$(      tput setaf 6)" # foreground to color #6 - cyan
export WHITE="$(     tput setaf 7)" # foreground to color #7 - white
export FGDEFAULT="$( tput setaf 9)" # default foreground color
