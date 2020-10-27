#!/bin/sh

LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"

case $1 in
    start)
        date > "$LOG_FILE"
        /sbin/insmod "${SYNOPKG_PKGDEST}/${SYNOPKG_PKGNAME}/${SYNOPKG_PKGNAME}.ko" >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    stop)
        /sbin/rmmod "${SYNOPKG_PKGDEST}/${SYNOPKG_PKGNAME}/${SYNOPKG_PKGNAME}.ko" >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    status)
        /sbin/lsmod | grep -q "$SYNOPKG_PKGNAME" && exit 0 || exit 3
        ;;
    log)
        [ ! -r "$LOG_FILE" ] || echo "$LOG_FILE"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
