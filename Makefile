# Makefile - makefile for tools

# get current locations
MAKEFILE            := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR             := $(patsubst %/,%,$(dir $(MAKEFILE)))
PWD                 := $(shell pwd)

# include user configuration file
sinclude $(PWD)/.config.mk

# includes configuration file
include $(TOP_DIR)/rules/settings.mk

# setup build locations
BUILD_DIR           := $(PWD)/build
SRC_DIR             := $(PWD)/sources
RULES_DIR           := $(PWD)/rules
PKG_DIR             := $(RULES_DIR)/packages
PYTHONENV_DIR       := $(TOP_DIR)/env
PATH                := $(GNAT_PREFIX_PATH)/bin:$(PATH)

GPR_PROJECT_PATH    := $(SRC_DIR)/gnatcoll-bindings/iconv:$(SRC_DIR)/gnatcoll-bindings/gmp
GPR_PROJECT_PATH    += $(SRC_DIR)/VSS/gnat:$(SRC_DIR)/libadalang-tools/src
GPR_PROJECT_PATH    += $(SRC_DIR)/ada_language_server/gnat

# check processor numbers.
MAKE_MAX_JOBS       := 8
LIST_NMAX            = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | tail -1)
LIST_NMIN            = $(shell echo '$(strip $(1))' | tr ' ' '\n' | sort -n | head -1)
NPROCS              := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
JOBS_AUTO           := $(call LIST_NMIN, $(MAKE_MAX_JOBS) $(NPROCS))
JOBS                := $(strip $(if $(findstring undefined,$(origin JOBS)),\
                       $(if $(and $(MAKECMDGOALS),$(filter $(MAKECMDGOALS),$(PKGS))), \
                            $(info [using autodetected $(JOBS_AUTO) job(s)])) $(JOBS_AUTO),$(JOBS)))

# build tool definitions
SHELL               := bash
DATE                := $(shell gdate --help >/dev/null 2>&1 && echo g)date
INSTALL             := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
LIBTOOL             := $(shell glibtool --help >/dev/null 2>&1 && echo g)libtool
LIBTOOLIZE          := $(shell glibtoolize --help >/dev/null 2>&1 && echo g)libtoolize
PATCH               := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
GIT_GET             := git clone --branch
MAKE                := make -j$(JOBS)
MAKE1               := make

# common build options
CONFIG_OPTS         := --prefix=$(INSTALL_DIR)
LIB_OPTS            := --prefix=$(LIB_DIR)
TIMESTAMP           := $(shell date +%Y%m%d)
TOOLS_VERSION       := GCC tools $(TIMESTAMP)

# export variables
export PATH GPR_PROJECT_PATH

# getting required branch from the GIT repository
define PREPARE_PKG_SOURCE
	$(foreach pkg,$(PKGS),$(GIT_GET) $($(pkg)_BRANCH)  $($(pkg)_URL) $(SRC_DIR)/$($(pkg)_SUBDIR);)
endef

.PHONY: all get-pkgs build clean help clean_pkgs clean_builds clobber build_setup build_gcc_first
.PHONY: build_newlib build_gcc_final

all: help

get-pkgs:
	@echo get packages
	$(call PREPARE_PKG_SOURCE)

build-setup:
	@echo make uses $(JOBS) threads.
	@mkdir -p $(TOP_DIR)/build

build-pythonenv:
	@echo make python3 virtual environment
	python3 -m venv env
	source env/bin/activate &&                                 \
	$(TOP_DIR)/env/bin/python3 -m pip install --upgrade pip && \
	pip install -r $(SRC_DIR)/langkit/REQUIREMENTS.dev &&      \
	pip install -r $(SRC_DIR)/libadalang/REQUIREMENTS.dev
	cd env &&                                                  \
	ln -s /usr/local/opt/python3/Frameworks Frameworks

build-pkg-%:
	@echo " "
	@echo [START $*]-----------------------------------------------------------
	@echo " "
	@echo Start building $* package for $(HOST) host for $(TARGET) architecture
	$(call $*_BUILD_$(HOST),$*)
	@echo " "
	@echo [END $*]-------------------------------------------------------------
	@echo " "

build-all:
	@echo build all
	@echo package lists: $(BUILD_LIST)
	$(MAKE1) -f $(MAKEFILE) build-setup
	$(MAKE1) -f $(MAKEFILE) get-pkgs
	$(MAKE1) -f $(MAKEFILE) build-pythonenv
	for pkg in $(BUILD_LIST);do $(MAKE1) -f $(MAKEFILE) build-pkg-$$pkg; done

clean:
	@echo clean build outputs.
	rm -rf $(TOP_DIR)/build
	rm -f *.txt

clobber: clean
	rm -rf $(SRC_DIR)
	rm -rf $(BUILD_DIR)
	rm -rf $(PYTHONENV_DIR)

help:
	@echo "make build-all - rebuild all packages"
	@echo "make get-pkgs  - get package source from the github"
	@echo "make clobber   - delete all sources"

include $(patsubst %,$(PKG_DIR)/%.mk,$(PKGS))

## END ##
