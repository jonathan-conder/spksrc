#!/bin/sh

LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"

wgnn_for_each() {
    local cmd netns
    cmd="$1"
    shift

    if [ $# -le 0 ]; then
        while read -r netns; do
            set -- "$@" "$netns"
        done < "${SYNOPKG_PKGDEST}/etc/${SYNOPKG_PKGNAME}/enabled"
    fi

    for netns in "$@"; do
        "$cmd" "$netns" || return $?
    done
}

wgnn_source() {
    wgnn_netns="$1"
    wgnn_conf="${SYNOPKG_PKGDEST}/etc/${SYNOPKG_PKGNAME}/${wgnn_netns}"
    wgnn_iface="wg-${wgnn_netns}"
    wgnn_veth="ve-${wgnn_netns}"
    wgnn_vpeer="vp-${wgnn_netns}"
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
    ip -n "$wgnn_netns" "$proto" address add "$1" dev "$wgnn_iface"
}

wg_pre_up() { :; }
wg_addr() { :; }
wg_post_up() { :; }
wg_pre_down() { :; }
wg_post_down() { :; }

wgnn_set_dns() {
    local src="/etc/netns/${wgnn_netns}"
    mkdir -p "$src"
    cp "${wgnn_conf}/resolv.conf" "${src}/"
}

wgnn_unset_dns() {
    local src="netns/${wgnn_netns}"
    rm -f "/etc/${src}/resolv.conf"
    (cd '/etc' && rmdir -p "$src" 2>/dev/null || true)
}

wgnn_start() (
    set -e

    wgnn_source "$1"

    local key ips ip proto

    wg_pre_up

    ip netns add "$wgnn_netns"
    ip -n "$wgnn_netns" link set lo up

    ip link add "$wgnn_iface" type wireguard
    ip link set "$wgnn_iface" netns "$wgnn_netns"

    ip netns exec "$wgnn_netns" wg setconf "$wgnn_iface" "${wgnn_conf}/wg.conf"
    wg_addr

    ip -n "$wgnn_netns" link set "$wgnn_iface" up ${wg_mtu+mtu "$wg_mtu"}
    wgnn_set_dns

    ip netns exec "$wgnn_netns" wg show "$wgnn_iface" allowed-ips | while read -r key ips; do
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
        ip -n "$wgnn_netns" "$proto" route add "$ip" dev "$wgnn_iface" ${wg_table+table "$wg_table"}
    done

    ip netns exec "$wgnn_netns" "$0" post_up "$1"

    ip link add "$wgnn_veth" type veth peer name "$wgnn_vpeer" netns "$wgnn_netns"

    ip -4 address add "$veth_addr" dev "$wgnn_veth"
    ip -n "$wgnn_netns" -4 address add "$vpeer_addr" dev "$wgnn_vpeer"

    ip link set up "$wgnn_veth"
    ip -n "$wgnn_netns" link set up "$wgnn_vpeer"
)

wgnn_stop() (
    wgnn_source "$1"

    ip link delete dev "$wgnn_veth"

    ip netns exec "$wgnn_netns" "$0" pre_down "$1"

    ip -n "$wgnn_netns" link delete dev "$wgnn_iface"
    wgnn_unset_dns

    wg_post_down

    ip netns delete "$wgnn_netns"
)

wgnn_post_up() (
    wgnn_source "$1"
    wg_post_up
)

wgnn_pre_down() (
    wgnn_source "$1"
    wg_pre_down
)

wgnn_status() (
    wgnn_source "$1"
    ping -c 1 -W 2 "${vpeer_addr%/*}" &>/dev/null && return 0 || return 3
)

mode="$1"
shift
case "$mode" in
    start)
        date > "$LOG_FILE"
        wgnn_for_each wgnn_start "$@" >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    stop)
        wgnn_for_each wgnn_stop "$@" >> "$LOG_FILE" 2>&1
        exit $?
        ;;
    post_up)
        wgnn_for_each wgnn_post_up "$@"
        exit $?
        ;;
    pre_down)
        wgnn_for_each wgnn_pre_down "$@"
        exit $?
        ;;
    status)
        wgnn_for_each wgnn_status "$@"
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
