# Log output to screen and file
log() {
    echo "`$DATE '+%Y-%m-%d %H:%M:%S'` : $@"
    echo "`$DATE '+%Y-%m-%d %H:%M:%S'` : $@" >> $LOGFILE
}

# Simple yes/no prompt
# Usage: if yesno "Do stuff?"; then do_stuff; fi
yesno() {
    local REPLY
    echo -n "$@ (y/n) "
    read
    while [[ "$REPLY" != "n" && $REPLY != "y" ]]; do
        echo -n "Valid answers are y, n"
        read
    done
    # log the question and answer
    log "$@ (y/n) $REPLY"
    # Return true if we answered yes
    [[ $REPLY == 'y' ]]
}

# Exit if not running as root
require_root() {
    if [[ $UID != 0 ]]; then
        echo This script must be run as root
        exit 1
    fi
}

##############################################################################
## Test functions
##############################################################################
plan() {
    log "Planning to run $1 tests"
    TESTS_TOTAL=$1
    TESTS_RUN=0
    TESTS_OK=0
}

ok_if() {
    (( TESTS_RUN++ ))
    echo -n "Running test: $@ ... "
    if "$@"; then
        echo "[${GREEN}OK${RESET}]"
        (( TESTS_OK++ ))
    else
        echo "[${RED}FAILED${RESET}]"
    fi
}

finish() {
    echo "Tests run:        $TESTS_RUN"
    echo "Tests successful: $TESTS_OK"
    if [[ $TESTS_RUN -ne $TESTS_TOTAL ]]; then
        echo "${RED}ERROR:${RESET} incorrect number of tests run"
    fi
    if [[ $TESTS_OK -lt $TESTS_RUN ]]; then
        echo "${RED}ERROR:${RESET} some tests failed"
    else
        echo "${GREEN}SUCCESS:${RESET} all tests that were run succeeded"
    fi
}
