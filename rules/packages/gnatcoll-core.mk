# gnatcoll-core.mk - makefile for gnatcoll-core

PKG              := gnatcoll-core
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-core.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR) && \
    $(MAKE) &&                      \
    $(MAKE) install
endef
