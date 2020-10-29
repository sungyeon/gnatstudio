# glib.mk - makefile for GLib

PKG              := glib
$(PKG)_VERSION   := glib-2-66
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://github.com/GNOME/glib.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&               \
    ./configure --prefix=$(GNAT_PREFIX_PATH)
endef
