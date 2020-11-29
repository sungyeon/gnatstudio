# langkit.mk - makefile for langkit

PKG              := langkit
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/langkit.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST)
    source $(PYTHONENV_DIR)/bin/activate && \
    cd $(SRC_DIR)/$(1) &&                   \
    export PYTHONPATH=$(SRC_DIR)/$(1) &&    \
    pip install . && \
    python3 manage.py make && \
    python3 manage.py build-langkit-support --library-types=static,static-pic,relocatable && \
    python3 manage.py install-langkit-support --library-types=static,static-pic,relocatable $(GNAT_PREFIX_PATH)
endef
