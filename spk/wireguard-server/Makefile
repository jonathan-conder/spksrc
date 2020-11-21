SPK_NAME = wireguard-server
SPK_VERS = 1.0.20200827
SPK_REV = 1
SPK_ICON = src/wireguard.png

BUILD_DEPENDS = cross/wireguard-tools
SPK_DEPENDS = wireguard

MAINTAINER = jonathan-conder
DESCRIPTION = VPN server using WireGuard.
DISPLAY_NAME = WireGuard server
HELPURL = https://www.wireguard.com
LICENSE = GPLv2

POST_STRIP_TARGET = wg-parse

CONF_DIR = src/conf
FWPORTS = src/$(SPK_NAME).sc
STARTABLE = yes
SSS_SCRIPT = src/dsm-control.sh
SPK_COMMANDS = etc/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

.PHONY: wg-parse

wg-parse:
	src/wg-parse $(STAGING_INSTALL_PREFIX)/bin/wg-quick src/wg/wg.conf $(STAGING_DIR)/etc/$(SPK_NAME)
