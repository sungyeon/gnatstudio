# libadalang.mk - makefile for libadalang

PKG              := libadalang
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/libadalang.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                 \
    python3 -m pip install --user virtualenv  &&    \
    python3 -m venv env &&                          \
    source env/bin/activate &&                      \
    pip install -r REQUIREMENTS.dev &&              \
    python3 ada/manage.py generate &&               \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-bindings/gmp:$(SRC_DIR)/gnatcoll-bindings/iconv && \
    python3 ada/manage.py --library-types=static,static-pic,relocatable build &&                   \
    python3 ada/manage.py --library-types=static,static-pic,relocatable install $(GNAT_PREFIX_PATH)
endef
