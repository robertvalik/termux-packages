TERMUX_PKG_HOMEPAGE=http://w-calc.sourceforge.net
TERMUX_PKG_DESCRIPTION="Capable calculator"
TERMUX_PKG_VERSION=2.5
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/w-calc/wcalc-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_DEPENDS="flex,libmpfr,libgmp,readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes"
