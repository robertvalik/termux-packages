TERMUX_PKG_VERSION=4.8.14
TERMUX_PKG_HOMEPAGE=https://www.midnight-commander.org/
TERMUX_PKG_DESCRIPTION="Midnight Commander - a powerful file manager"
TERMUX_PKG_SRCURL="http://ftp.midnight-commander.org/mc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_DEPENDS="ncurses, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ncurses-libs=$TERMUX_PREFIX/lib --with-screen=ncurses"
# mc uses the deprecated S_IREAD and S_IWRITE definitions, which android does not define:
# https://code.google.com/p/android/issues/detail?id=19710
CPPFLAGS="$CPPFLAGS -DS_IREAD=S_IRUSR -DS_IWRITE=S_IWUSR"
