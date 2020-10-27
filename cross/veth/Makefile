PKG_NAME = veth
PKG_DIR = veth

REQUIRE_KERNEL = 1

HOMEPAGE = https://kernel.org
COMMENT = Virtual ethernet pair device
LICENSE = GPLv2

DOWNLOAD_TARGET = veth-download
CONFIGURE_TARGET = nope
COMPILE_TARGET = veth-compile
INSTALL_TARGET = veth-install

include ../../mk/spksrc.cross-cc.mk

.PHONY: veth-download veth-compile veth-install

veth-download:
	mkdir -p $(WORK_DIR)/$(PKG_DIR)
	$(RUN) cp $(KERNEL_DIR)/drivers/net/veth.c .
	$(RUN) echo 'obj-m := veth.o' > Kbuild

veth-compile:
	$(RUN) $(MAKE) -C $(KERNEL_DIR) M=$$PWD

veth-install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/veth
	$(RUN) install -m 644 veth.ko $(STAGING_INSTALL_PREFIX)/veth
