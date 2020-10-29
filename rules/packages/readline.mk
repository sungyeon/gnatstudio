# readline.mk - makefile for readline

PKG              := readline
$(PKG)_VERSION   := readline-6.3
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://git.savannah.gnu.org/git/readline.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
$(PKG)_BUILD_DIR := $(BUILD_DIR)/$($(PKG)_SUBDIR)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    mkdir -p $($(1)_BUILD_DIR)
    cd $($(1)_BUILD_DIR) &&                                         \
    $(SRC_DIR)/$($(1)_SUBDIR)/configure --prefix=$(GPS_INSTALL_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR)
    $(MAKE) -C $($(1)_BUILD_DIR) install
endef
