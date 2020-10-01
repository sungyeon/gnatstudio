# Makefile - makefile for T tools

# get current locations
MAKEFILE            := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
TOP_DIR             := $(patsubst %/,%,$(dir $(MAKEFILE)))
PWD                 := $(shell pwd)

# include user configuration file
sinclude $(PWD)/.config.mk

# includes configuration file
include $(TOP_DIR)/rules/settings.mk

# setup build locations
PREFIX              := $(PWD)/usr
BUILD_DIR           := $(PWD)/build
SRC_DIR             := $(PWD)/sources
RULES_DIR           := $(PWD)/rules
PKG_DIR             := $(RULES_DIR)/packages
INSTALL_DIR         := $(PREFIX)/$(HOST)
LIB_DIR             := $(PREFIX)/$(HOST)_lib
NATIVE_INSTALL_DIR  := $(PREFIX)/$(BUILD_HOST)
NATIVE_LIB_DIR      := $(PREFIX)/$(BUILD_HOST)_lib
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
	for pkg in $(BUILD_LIST);do $(MAKE1) -f $(MAKEFILE) build-pkg-$$pkg; done

clean:
	@echo clean build outputs.
	rm -rf $(TOP_DIR)/build
	rm -f *.txt

clobber: clean
	rm -rf $(SRC_DIR)
	rm -rf $(PREFIX)/*
	rm -rf $(PREFIX)

print_env:
	@echo INSTALL_DIR=$(INSTALL_DIR)
	@echo PATH=$(PATH)

help:
	@echo "Help!!"

include $(patsubst %,$(PKG_DIR)/%.mk,$(PKGS))

## END ##
