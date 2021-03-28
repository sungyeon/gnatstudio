# gnatcoll-bindings.mk - makefile for gnatcoll-bindings

PKG              := gnatcoll-bindings
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-bindings.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_PREFIX    := $(shell python3-config --prefix)
PYTHON_H_PATH    := $(PYTHON_PREFIX)/Headers
PYTHON_LIB_PATH  := $(PYTHON_PREFIX)/lib

$(PKG)_BINDING_LIST := zlib syslog readline omp iconv gmp
define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    export C_INCLUDE_PATH=$(PYTHON_H_PATH) &&               \
    source $(PYTHONENV_DIR)/bin/activate &&                 \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                         \
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py build; done && \
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py install; done
    cd $(SRC_DIR)/$($(1)_SUBDIR)/python3 && ./setup.py build --python-exec=python3 && \
    ./setup.py install
endef
