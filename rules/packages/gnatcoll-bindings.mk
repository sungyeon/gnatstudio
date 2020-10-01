# gnatcoll-bindings.mk - makefile for gnatcoll-bindings

PKG              := gnatcoll-bindings
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-bindings.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

$(PKG)_BINDING_LIST := zlib syslog readline omp iconv gmp
define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py build; done
endef
