SPK_NAME = wireguard
SPK_VERS = 1.0.20200908
SPK_REV = 1
SPK_ICON = src/wireguard.png

DEPENDS = cross/$(SPK_NAME) cross/$(SPK_NAME)-tools

MAINTAINER = jonathan-conder
DESCRIPTION = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
DISPLAY_NAME = WireGuard
HOMEPAGE = https://www.wireguard.com
LICENSE = GPLv2

CONF_DIR = src/conf
STARTABLE = yes
SSS_SCRIPT = src/dsm-control.sh
SPK_COMMANDS = bin/wg bin/wg-quick

include ../../mk/spksrc.spk.mk
