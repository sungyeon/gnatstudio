# gps.mk - makefile for GNAT Studio

PKG              := gps
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gps.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_PREFIX    := $(shell python-config --prefix)
PYTHON_H_PATH    := $(PYTHON_PREFIX)/Headers
PYTHON_LIBS      := $(shell python-config --libs)
PYTHON_LDFLAGS   := $(shell python-config --ldflags)
LIBCLANG_PATH    := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) path=$(PYTHON_INC_PATH)
    export GNATCOLL_PYTHON_LIBS="$(PYTHON_LDFLAGS)" && \
    export C_INCLUDE_PATH=$(PYTHON_H_PATH) &&          \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-bindings/python:$(SRC_DIR)/libadalang-tools/src:$(SRC_DIR)/ada_language_server/gnat:$(SRC_DIR)/VSS/gnat && \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                     \
    ./configure --prefix=$(GNAT_PREFIX_PATH) --with-clang=$(LIBCLANG_PATH) && \
    $(MAKE) &&                                          \
    $(MAKE1) install
endef
