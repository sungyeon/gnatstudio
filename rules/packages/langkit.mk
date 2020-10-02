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
    ./manage.py make
endef
