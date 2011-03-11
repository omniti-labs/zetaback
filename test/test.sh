#!/bin/bash
SRCPOOL=zbsrctest
DSTPOOL=zbdsttest
POOLSIZE=100M

LOGFILE=zbtest.log

# Commands
ZPOOL=/usr/sbin/zpool
ZFS=/usr/sbin/zfs
DATE=/bin/date
ZETABACK=$PWD/../zetaback

# Utility functions
log() {
    echo "`$DATE '+%Y-%m-%d %H:%M:%S'` : $@"
    echo "`$DATE '+%Y-%m-%d %H:%M:%S'` : $@" >> $LOGFILE
}

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

require_root() {
    if [[ $UID != 0 ]]; then
        echo This script must be run as root
        exit 1
    fi
}

# Test script specific functions
delete_pool_if_exists() {
    if $ZPOOL list -H -o name | grep "^$1$" > /dev/null; then
        if yesno "About to destroy zpool $1. OK to destroy?"; then
            log "Destroying $1"
            $ZPOOL destroy $1
        else
            log "Not destroying $1"
        fi
    fi
}

create_zpool() {
    local FILENAME
    FILENAME=/var/tmp/$1.zpool
    log "Removing $FILENAME if it exists"
    rm -f $FILENAME
    log "Making $POOLSIZE file $FILENAME"
    mkfile $POOLSIZE $FILENAME
    log "Making new file based zpool: $1 on $FILENAME"
    $ZPOOL create $1 $FILENAME
}

create_zfs() {
    log "Creating zfs filesystem $1"
    `$ZFS create $1`
}

create_test_filesystems() {
    create_zfs $SRCPOOL/test
    create_zfs $SRCPOOL/test/foo
    create_zfs $SRCPOOL/test/foo/bar
    create_zfs $SRCPOOL/test/baz
}

generate_zetaback_conf() {
    log "Generating zetaback config"
    cat > zetaback_test.conf <<EOF
default {
    store = /$DSTPOOL/%h
    archive = /$DSTPOOL/archives
    agent = "$PWD/../zetaback_agent -c $PWD/zetaback_agent_test.conf"
    backup_interval = 10
    full_interval = 604800
    dataset_backup = 1
    dataset_recursive = 1
    retention = 10
}

$HOSTNAME { }
EOF
}

generate_zetaback_agent_conf() {
    log "Generating zetaback agent config"
    cat > zetaback_agent_test.conf <<EOF
pattern=(?:$SRCPOOL/test)
EOF
}

run_zetaback() {
    OPTIONS="-d -b -x -c $PWD/zetaback_test.conf"
    log "Running zetaback $OPTIONS"
    $ZETABACK $OPTIONS 2>&1 | tee -a $LOGFILE
}

zetaback_ignore() {
    log "Setting zetaback ignore user property on $1"
    `zfs set com.omniti.labs.zetaback:exclude=on $1`
}

### Main program thread
require_root
# Set up filesystems
if yesno "(Re)create zpools?"; then
    delete_pool_if_exists $SRCPOOL
    delete_pool_if_exists $DSTPOOL
    create_zpool $SRCPOOL
    create_zpool $DSTPOOL
    zetaback_ignore $DSTPOOL
    create_test_filesystems
fi
# Create config files
generate_zetaback_conf
generate_zetaback_agent_conf
# Run zetaback
run_zetaback
