# libadalang.mk - makefile for libadalang

PKG              := libadalang
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/libadalang.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    source $(PYTHONENV_DIR)/bin/activate &&         \
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                 \
    python3 manage.py generate &&                   \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-bindings/gmp && \
    python3 manage.py build --library-types=static,static-pic,relocatable &&                   \
    python3 manage.py make  --library-types=static,static-pic,relocatable && \
    python3 manage.py install $(GNAT_PREFIX_PATH) --library-types=static,static-pic,relocatable
endef
