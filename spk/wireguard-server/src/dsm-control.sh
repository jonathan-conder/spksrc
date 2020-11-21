#!/bin/sh

LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"

wgnn_source() {
    wgnn_conf="${SYNOPKG_PKGDEST}/etc/${SYNOPKG_PKGNAME}"
    wgnn_iface='wg0'
    . "${wgnn_conf}/hooks.sh"
}

wg_ip_addr() {
    local proto
    case "$1" in
        *:*)
            proto='-6'
            ;;
        *)
            proto='-4'
            ;;
    esac
    ip "$proto" address add "$1" dev "$wgnn_iface"
}

wg_pre_up() { :; }
wg_addr() { :; }
wg_post_up() { :; }
wg_pre_down() { :; }
wg_post_down() { :; }

wgnn_start() (
    set -e

    wgnn_source

    local key ips ip proto

    wg_pre_up

    ip link add "$wgnn_iface" type wireguard
    wg setconf "$wgnn_iface" "${wgnn_conf}/wg.conf"
    wg_addr

    ip link set "$wgnn_iface" up ${wg_mtu+mtu "$wg_mtu"}

    wg show "$wgnn_iface" allowed-ips | while read -r key ips; do
        printf '%s\n' $ips
    done | sort -nr -k 2 -t / | while read -r ip; do
        case "$ip" in
            *:*)
                proto='-6'
                ;;
            *)
                proto='-4'
                ;;
        esac
        ip "$proto" route add "$ip" dev "$wgnn_iface" ${wg_table+table "$wg_table"}
    done

    wg_post_up
)

wgnn_stop() (
    wgnn_source

    wg_pre_down
    ip link delete dev "$wgnn_iface"
    wg_post_down
)

wgnn_status() (
    wgnn_source

    wg show "$wgnn_iface" &>/dev/null && return 0 || return 3
)

case "$1" in
    start)
        date > "$LOG_FILE"
        wgnn_start >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    stop)
        wgnn_stop >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    status)
        wgnn_status
        exit $?
        ;;
    log)
        [ ! -r "$LOG_FILE" ] || echo "$LOG_FILE"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
