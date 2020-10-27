PKG_NAME = wireguard-tools
PKG_VERS = 1.0.20200827
PKG_EXT = tar.xz
PKG_DIST_SITE = https://git.zx2c4.com/$(PKG_NAME)/snapshot
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://www.wireguard.com
COMMENT = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
LICENSE = GPLv2

BUILD_DEPENDS = cross/libmnl

CONFIGURE_TARGET = nope
COMPILE_TARGET = wireguard-tools-compile
INSTALL_TARGET = wireguard-tools-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: wireguard-tools-compile wireguard-tools-install

wireguard-tools-compile:
	$(RUN) $(MAKE) -C src

wireguard-tools-install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	$(RUN) install -m 755 src/wg $(STAGING_INSTALL_PREFIX)/bin/
	$(RUN) install -m 755 src/wg-quick/linux.bash $(STAGING_INSTALL_PREFIX)/bin/wg-quick
