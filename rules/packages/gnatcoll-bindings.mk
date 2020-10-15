# gnatcoll-bindings.mk - makefile for gnatcoll-bindings

PKG              := gnatcoll-bindings
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-bindings.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_PREFIX    := $(shell python-config --prefix)
PYTHON_H_PATH    := $(shell find /usr/local/Cellar/ -name Python.h)
PYTHON_INC_PATH  := $(shell echo $(PYTHON_H_PATH) | sed 's/\(.*\)\/.*/\1/')
PYTHON_LIB_PATH  := /usr/local/Cellar/python@3.8/3.8.5/Frameworks/Python.framework/Versions/Current/lib

$(PKG)_BINDING_LIST := zlib syslog readline omp iconv gmp python
define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    export GNATCOLL_PYTHON_LIBS="-L$(PYTHON_LIB_PATH) -lpython3.8 -ldl -framework CoreFoundation" && \
    export C_INCLUDE_PATH=$(PYTHON_INC_PATH) &&     \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                 \
    git apply $(PKG_DIR)/gnatcoll-bindings.patch    \
    git apply $(PKG_DIR)/gnatcoll-bindings-python.patch
    source $(PYTHONENV_DIR)/bin/activate &&         \
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py build; done && \
    for pkg in $($(1)_BINDING_LIST); do cd $(SRC_DIR)/$($(1)_SUBDIR)/$$pkg && ./setup.py install; done
endef
