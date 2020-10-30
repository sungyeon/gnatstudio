# libffi.mk - makefile for libffi

PKG              := libffi
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://github.com/libffi/libffi.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&            \
    ./autogen.sh &&                             \
    ./configure --prefix=$(GPS_INSTALL_DIR) && \
    $(MAKE) install
endef
