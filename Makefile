# Copyright 2015 
# Matthew

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-cifs-app
PKG_VERSION:= 0.1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/luci-cifs-app
	SECTION:=net
	CATEGORY:=Network
	TITLE:=mounting Nat drives
	DEPENDS:=+kmod-fs-cifs
endef

define Package/luci-cifs-app/description
Allows you using luci to mount networked drives.
endef

define Package/luci-cifs-app/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller

	$(INSTALL_CONF) ./files/dnsforwarder.config $(1)/etc
	$(INSTALL_CONF) ./files/cifs-config $(1)/etc/config/cifs
	$(INSTALL_BIN) ./files/cifs-init.d.sh $(1)/etc/init.d/cifs
	$(INSTALL_DATA) ./files/cifs-controller.lua $(1)/usr/lib/lua/luci/controller/cifs.lua
	$(INSTALL_DATA) ./files/cifs-model.lua $(1)/usr/lib/lua/luci/model/cbi/cifs.lua
	endef


$(eval $(call BuildPackage,luci-cifs-app))
