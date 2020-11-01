service_prestart() {
    local command netns
    command="${SYNOPKG_PKGDEST}/bin/${SYNOPKG_PKGNAME}"
    [ -n "$SERVICE_SHELL" ] || SERVICE_SHELL=/bin/sh

    while read -r netns; do
        ip netns exec "$netns" \
            su "$EFF_USER" -s "$SERVICE_SHELL" -c \
            "exec ${command}" >> "$LOG_FILE" 2>&1 &
        echo "$!"
    done < "${SYNOPKG_PKGDEST}/etc/${SYNOPKG_PKGNAME}/netns" > "$PID_FILE"
}
