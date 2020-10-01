# gps.mk - makefile for GNAT Studio

PKG              := gps
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gps.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

LIBCLANG_PATH    := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    cd $(SRC_DIR)/$($(1)_SUBDIR) && \
    ./configure --prefix=$(GNAT_PREFIX_PATH) --with-clang=$(LIBCLANG_PATH) && \
    make
endef
