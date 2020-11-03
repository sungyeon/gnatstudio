# gettext.mk - makefile for gettext

PKG              := gettext
$(PKG)_VERSION   := master
$(PKG)_SUBDIR    := $(PKG)
$(PKG)_URL       := https://github.com/sungyeon/gettext.git
$(PKG)_BRANCH    := $($(PKG)_VERSION)

define $(PKG)_BUILD_$(HOST)
    @echo Building $(1) package for $(HOST) host
    LC_CTYPE=C &&                           \
    cd $(SRC_DIR)/$($(1)_SUBDIR)/ &&        \
    ./autogen.sh --skip-gnulib &&           \
    ./configure --prefix=$(GNAT_PREFIX_PATH) \
    --disable-dependency-tracking   \
    --disable-silent-rules          \
    --disable-debug                 \
    --with-included-gettext         \
    gl_cv_func_ftello_works=yes     \
    --with-included-glib            \
    --with-included-libcroco        \
    --with-included-libunistring    \
    --without-emacs                 \
    --disable-java                  \
    --disable-csharp                \
    --without-git                   \
    --without-cvs                   \
    --without-xz &&                 \
    $(MAKE) install
endef
