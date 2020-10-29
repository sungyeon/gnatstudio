# gnatcoll-db.mk - makefile for gnatcoll-db

PKG              := gnatcoll-db
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := $(GITHUB_ADACORE_URL)/gnatcoll-db.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

$(PKG)_MODULE_LIST  := sql sqlite postgres xref gnatcoll_db2ada gnatinspect

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    cd $(SRC_DIR)/$($(1)_SUBDIR) &&                                                         \
    export GPR_PROJECT_PATH=$(SRC_DIR)/gnatcoll-db/sql:$(SRC_DIR)/gnatcoll-db/sqlite:$(SRC_DIR)/gnatcoll-db/xref &&     \
    for pkg in $($(1)_MODULE_LIST); do $(MAKE) -C $$pkg; done &&                            \
    for pkg in $($(1)_MODULE_LIST); do $(MAKE) -C $$pkg install; done
endef
