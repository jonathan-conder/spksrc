PKG_NAME = microsocks
PKG_VERS = 1.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rofl0r/$(PKG_NAME)/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

HOMEPAGE = https://github.com/rofl0r/microsocks
COMMENT  = Tiny, portable SOCKS5 server with very moderate resource usage
LICENSE  = MIT

CONFIGURE_TARGET = nope
ADDITIONAL_CFLAGS = -O3 -DCONFIG_LOG=0

include ../../mk/spksrc.cross-cc.mk
