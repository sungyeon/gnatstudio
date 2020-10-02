# ada_language_server.mk - makefile for ada_language_server

PKG              := ada_language_server
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/ada_language_server.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    export GPR_PROJECT_PATH=$(SRC_DIR)/VSS/gnat:$(SRC_DIR)/libadalang-tools/src && \
    cd $(SRC_DIR)/$($(1)_SUBDIR) && \
    $(MAKE1) all &&                 \
    $(MAKE1) install DESTDIR=$(GNAT_PREFIX_PATH)
endef
