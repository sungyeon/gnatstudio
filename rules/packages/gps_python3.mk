# gps.mk - makefile for GNAT Studio

PKG              := gps
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gps.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_PREFIX    := $(shell python3-config --prefix)
PYTHON_H_PATH    := $(PYTHON_PREFIX)/Headers
PYTHON_LIB_PATH  := $(PYTHON_PREFIX)/lib
LIBCLANG_PATH    := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) path=$(PYTHON_INC_PATH)
    export GNATCOLL_PYTHON_LIBS="-L$(PYTHON_LIB_PATH) -lpython3.9 -ldl -framework CoreFoundation" && \
    export C_INCLUDE_PATH=$(PYTHON_H_PATH) &&            \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-bindings/python3:$(SRC_DIR)/libadalang-tools/src:$(SRC_DIR)/ada_language_server/gnat && \
    source $(PYTHONENV_DIR)/bin/activate &&              \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                      \
    ./configure --prefix=$(GNAT_PREFIX_PATH) --with-clang=$(LIBCLANG_PATH) && \
    $(MAKE) &&                                           \
    $(MAKE1) install
endef
