SPK_NAME = wireguard-netns
SPK_VERS = 1.0.20200827
SPK_REV = 1
SPK_ICON = src/wireguard.png

BUILD_DEPENDS = cross/wireguard-tools
SPK_DEPENDS = veth:wireguard

MAINTAINER = jonathan-conder
DESCRIPTION = Scripts for running WireGuard in a network namespace.
DISPLAY_NAME = WireGuard netns scripts
HELPURL = https://www.wireguard.com
LICENSE = GPLv2

POST_STRIP_TARGET = wg-parse

CONF_DIR = src/conf
STARTABLE = yes
SSS_SCRIPT = src/dsm-control.sh
SPK_COMMANDS = etc/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

.PHONY: wg-parse

wg-parse:
	src/wg-parse $(STAGING_INSTALL_PREFIX)/bin/wg-quick src/wg $(STAGING_DIR)/etc/$(SPK_NAME)
