# Copyright 2015 
# Matthew

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-cifs
PKG_VERSION:= 0.1
PKG_RELEASE:=2

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-cifs
	SECTION:=luci
	CATEGORY:=Luci
	SUBMENU:=3. Applications
	TITLE:=mounting Nat drives
	DEPENDS:=+kmod-fs-cifs
endef

define Package/luci-app-cifs/description
Allows you to use the Web Cotrol Center to mount networked drives.
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-cifs/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./files/cifs-config $(1)/etc/config/cifs
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/cifs-init.d.sh $(1)/etc/init.d/cifs.sh

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/cifs-controller.lua $(1)/usr/lib/lua/luci/controller/cifs.lua

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/cifs-model.lua $(1)/usr/lib/lua/luci/model/cbi/cifs.lua

	endef


$(eval $(call BuildPackage,luci-app-cifs))
