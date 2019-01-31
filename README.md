# Zetaback ZFS backup and recovery management system #

Zetaback is a thin-agent based ZFS backup tool.  It is designed to:

  * run from a central host
  * scan clients for new ZFS filesystems
  * manage varying desired backup intervals (per host) for
    * full backups
    * incremental backups
  * maintain varying retention policies (per host)
  * summarize existing backups
  * restore any host:fs backup at any point in time to any target host

## Prerequisites ##

  * Backup host with a '''LOT''' of disk space.
  * SSH in place where a user on the backup server can perform a password-less remote login to the clients (using ssh keys) and execute the agent script as root.
  * Perl 5 on client and server.
  * ZFS tools installed on client.

## Download ##

  * Download the code from git:
```
git clone git://labs.omniti.com/zetaback.git
cd zetaback
./autogen.sh
./configure
make
make install
```

## Project Info ##

  * [License](LICENSE)
  * Maintainer: jesus@omniti.com
  * Man pages are available after install

## Developer Info ##
  * [How to Make A Release](RELEASE) 
