# libadalang-tools.mk - makefile for libadalang-tools

PKG              := libadalang-tools
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/libadalang-tools.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    cd $(SRC_DIR)/$($(1)_SUBDIR) && \
    $(MAKE1)
endef
