# gmp.mk - makefile for gmp
# https://gmplib.org/repo/gmp

PKG              := gmp
$(PKG)_VERSION   := v6.2.0
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_URL)/sungyeon/gmp.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    mkdir -p $($(1)_BUILD_DIR)
    cd $($(1)_BUILD_DIR) &&                                             \
    CC=$(CC) CXX=$(CXX)                                                 \
    $(SRC_DIR)/$($(1)_SUBDIR)/configure --prefix=$(GNAT_PREFIX_PATH)    \
    --enable-cxx                                                        \
    --without-readline
    $(MAKE) -C $($(1)_BUILD_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR) install
endef
