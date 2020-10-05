# gps.mk - makefile for GNAT Studio

PKG              := gps
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gps.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)
PYTHON_H_PATH    := $(shell find /usr/local/Cellar/ -name Python.h)
PYTHON_INC_PATH  := $(shell echo $(PYTHON_H_PATH) | sed 's/\(.*\)\/.*/\1/')
PYTHON_LIB_PATH  := /usr/local/Cellar/python@3.8/3.8.5/Frameworks/Python.framework/Versions/Current/lib
LIBCLANG_PATH    := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) path=$(PYTHON_INC_PATH)
    export GNATCOLL_PYTHON_LIBS="-L$(PYTHON_LIB_PATH) -lpython3.8 -ldl -framework CoreFoundation" && \
    export C_INCLUDE_PATH=$(PYTHON_INC_PATH) &&         \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-bindings/python3:$(SRC_DIR)/libadalang-tools/src:$(SRC_DIR)/ada_language_server/gnat && \
    source $(PYTHONENV_DIR)/bin/activate &&              \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                      \
    ./configure --prefix=$(GNAT_PREFIX_PATH) --with-clang=$(LIBCLANG_PATH) && \
    $(MAKE) &&                                           \
    $(MAKE1) install
endef
