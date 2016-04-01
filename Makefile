# Copyright 2015 
# Matthew

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-cifs-app
PKG_VERSION:= 0.1
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	TITLE:=Mounting Nat Drives
	PKGARCH:=all
	DEPENDS:=+kmod-fs-cifs
endef

define Package/$(PKG_NAME)/description
	Allows you to use the Web Cotrol Center to mount networked drives.
endef

define Build/Prepare 
endef

define Build/Configure
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/cifs
/etc/init.d/cifs.sh
endef

define Package/$(PKG_NAME)/preinst
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
	/etc/init.d/cifs.sh enable
exit 0
endef

define Package/$(PKG_NAME)/prerm 
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/cifs-config $(1)/etc/config/cifs
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/cifs-init.d.sh $(1)/etc/init.d/cifs.sh

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/cifs-controller.lua $(1)/usr/lib/lua/luci/controller/cifs.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/cifs-model.lua $(1)/usr/lib/lua/luci/model/cbi/cifs.lua
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
