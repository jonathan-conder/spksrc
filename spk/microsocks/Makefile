SPK_NAME = microsocks
SPK_VERS = 1.0.1
SPK_REV = 1
SPK_ICON = src/microsocks.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = wireguard-netns

MAINTAINER = jonathan-conder
DESCRIPTION = Tiny, portable SOCKS5 server with very moderate resource usage
DISPLAY_NAME = MicroSocks
HOMEPAGE = https://github.com/rofl0r/microsocks
LICENSE  = MIT

POST_STRIP_TARGET = install-netns

CONF_DIR = src/conf
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
STARTABLE = yes
SPK_COMMANDS = etc/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

.PHONY: install-netns

install-netns:
	install -m 755 -d $(STAGING_DIR)/etc/$(SPK_NAME)
	install -m 644 src/netns $(STAGING_DIR)/etc/$(SPK_NAME)/netns
