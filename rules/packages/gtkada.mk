# gtkada.mk - makefile for gtkada

PKG              := gtkada
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gtkada.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&               \
    ./configure --prefix=$(GNAT_PREFIX_PATH) &&    \
    patch -p1 < $(PKG_DIR)/gtkada_patch01.patch && \
    $(MAKE1) &&                                    \
    $(MAKE1) install
endef
