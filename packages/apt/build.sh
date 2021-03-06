TERMUX_PKG_HOMEPAGE=https://packages.debian.org/apt
TERMUX_PKG_DESCRIPTION="Front-end for the dpkg package manager"
TERMUX_PKG_DEPENDS="libbz2, liblzma, libgnustl, dpkg, gnupg"
TERMUX_PKG_VERSION=1.0.10.2
TERMUX_PKG_SRCURL=http://ftp.debian.org/debian/pool/main/a/apt/apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--host=${TERMUX_ARCH}-linux --disable-rpath acl_cv_rpath=$TERMUX_PREFIX/lib gt_cv_func_CFPreferencesCopyAppValue=no gt_cv_func_CFLocaleCopyCurrent=no ac_cv_c_bigendian=no --no-create"
TERMUX_PKG_FOLDERNAME=apt-${TERMUX_PKG_VERSION}
TERMUX_PKG_ESSENTIAL=yes

# $NDK/docs/STANDALONE-TOOLCHAIN.html: "If you use the GNU libstdc++, you will need to explicitly link with libsupc++ if you use these features"
export LDFLAGS="$LDFLAGS -lgnustl_shared" # -lsupc++"

termux_step_pre_configure () {
	cp $TERMUX_COMMON_CACHEDIR/config.{guess,sub} $TERMUX_PKG_SRCDIR/buildlib
        perl -p -i -e "s/TERMUX_ARCH/$TERMUX_ARCH/" $TERMUX_PKG_SRCDIR/configure
}

termux_step_post_configure () {
        # This is needed to generate makefile, but does not work due to configure arguments not being remembered
        ./config.status
}

termux_step_make () {
        unset CC
        unset CFLAGS
        unset LDFLAGS
        unset CXX
        unset CXXFLAGS
        make
}

termux_step_make_install () {
        cp $TERMUX_PKG_BUILDDIR/bin/apt{,-get,-cache,-config,-key} $TERMUX_PREFIX/bin/
        cp $TERMUX_PKG_BUILDDIR/bin/libapt-{pkg.so.4.16,private.so.0.0} $TERMUX_PREFIX/lib/
        (cd $TERMUX_PREFIX/lib; rm -f libapt-pkg.so; ln -s libapt-pkg.so.4.16 libapt-pkg.so) # used by python-apt
        mkdir -p $TERMUX_PREFIX/lib/apt/methods $TERMUX_PREFIX/share/man/man{5,8}
        cp $TERMUX_PKG_BUILDDIR/docs/apt{,-cache,-get}.8 $TERMUX_PREFIX/share/man/man8/
        cp $TERMUX_PKG_BUILDDIR/docs/{apt.conf,sources.list}.5 $TERMUX_PREFIX/share/man/man5/
        cp $TERMUX_PKG_BUILDDIR/bin/methods/{copy,file,gpgv,gzip,http,https} $TERMUX_PREFIX/lib/apt/methods
        (cd $TERMUX_PREFIX/lib/apt/methods; ln -f -s gzip bzip2)

        mkdir -p $TERMUX_PREFIX/etc/apt
        printf "# The main termux repository:\ndeb [arch=all,${TERMUX_ARCH}] http://apt.termux.com stable main\n" > $TERMUX_PREFIX/etc/apt/sources.list

        # The trusted.gpg was created with "apt-key add public-key.key":
        cp $TERMUX_PKG_BUILDER_DIR/trusted.gpg $TERMUX_PREFIX/etc/apt/
}
