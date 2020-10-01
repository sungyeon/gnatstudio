# ada_language_server.mk - makefile for ada_language_server

PKG              := ada_language_server
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/ada_language_server.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&                \
    $(MAKE) &&                                      \
    $(MAKE) install DESTDIR=$(GNAT_PREFIX_PATH)
endef
