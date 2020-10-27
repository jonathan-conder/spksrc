PKG_NAME = wireguard
_PKG_NAME = wireguard-linux-compat
PKG_VERS = 1.0.20200908
PKG_EXT = tar.xz
PKG_DIST_SITE = https://git.zx2c4.com/$(_PKG_NAME)/snapshot
PKG_DIST_NAME = $(_PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(_PKG_NAME)-$(PKG_VERS)

REQUIRE_KERNEL = 1

HOMEPAGE = https://www.wireguard.com
COMMENT = WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache.
LICENSE = GPLv2

CONFIGURE_TARGET = nope
COMPILE_TARGET = wireguard-compile
INSTALL_TARGET = wireguard-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: wireguard-compile wireguard-install

wireguard-compile:
	$(RUN) $(MAKE) -C src KERNELDIR=$(KERNEL_DIR) module

wireguard-install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/wireguard
	$(RUN) install -m 644 src/wireguard.ko $(STAGING_INSTALL_PREFIX)/wireguard
