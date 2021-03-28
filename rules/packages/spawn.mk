# spawn.mk - makefile for process API.

PKG              := spawn
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/spawn.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&               \
    $(MAKE) OS=osx all install PREFIX=$(GNAT_PREFIX_PATH)
endef
