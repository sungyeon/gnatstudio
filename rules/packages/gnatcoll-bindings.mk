# gnatcoll-bindings.mk - makefile for gnatcoll-bindings

PKG              := gnatcoll-bindings
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-bindings.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_PREFIX    := $(shell python2.7-config --prefix)
PYTHON2_LIB_PATH := $(shell python2.7-config --ldflags)

$(PKG)_BINDING_LIST := zlib syslog readline omp iconv gmp python
define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    export GNATCOLL_PYTHON_LIBS="-L$(PYTHON2_LIB_PATH)" && \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                        \
    git apply $(PKG_DIR)/gnatcoll-bindings.patch &&        \
    git apply $(PKG_DIR)/gnatcoll-bindings-python.patch
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py build; done && \
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py install; done
endef
