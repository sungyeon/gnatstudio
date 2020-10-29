# settings.mk - configuration file for GPS tools.

# package list
PKGS        := zlib xz readline gmp gettext
#gettext libffi glib
#PKGS        += gtkada
#PKGS        += gnatcoll-core gnatcoll-bindings gnatcoll-db VSS
#PKGS        += langkit libadalang libadalang-tools ada_language_server
#PKGS        += gps

# library and utility build lists, gcc

BUILD_LIST  := zlib xz readline gmp
#BUILD_LIST  := gtkada gmp xz
#BUILD_LIST  += gnatcoll-core gnatcoll-bindings gnatcoll-db VSS
#BUILD_LIST  += langkit libadalang libadalang-tools ada_language_server gps

HOST        ?= $(shell uname -s)
TARGET      ?= native
BUILD_HOST  ?= Darwin       # Darwin Linux
BUILD_OS    := $(shell uname)

# Is macOS ?
ifeq ($(BUILD_OS),Darwin)
BUILD_HOST  = Darwin
endif

# This variable specifies git server URL that saves required sources
GITHUB_URL         := https://github.com
GITHUB_ADACORE_URL := $(GITHUB_URL)/AdaCore

# END
