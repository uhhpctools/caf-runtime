Copyright 2010 Hewlett Packard Company

Copyright 2011-2014 University of Houston

This file is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

This file is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this file; ; see the file osprey/COPYING.  If not, see
<http://www.gnu.org/licenses/>.


# When modifying this file, configure.ac, the person making the changes
# should use autoconf 2.59 to regenerate the configure script.  Both
# configure.ac and configure should be checked in to subversion.  This is
# so that developers or users can build open64 without needing autoconf on
# their systems.

# It may be necessary from time to time to also update some of the files
# used by autoconf.  These are config.guess, config.sub, install-sh.
# The official versions of these three files are actually part of automake
# (which open64 does not use).  If any of these files need updating, the
# required change should be made to the latest automake sources first
# (if they are not already there) and then the files should be copied
# from the automake sources to our source tree.  Our versions of these
# files should always match some version of the automake sources and
# not diverge by having local changes in them.


AC_PREREQ([2.59])
AC_INIT([opencc],[4.2])
AC_CANONICAL_HOST
AC_CANONICAL_TARGET
#AC_PROG_CC
#AC_PROG_CXX
#AC_PROG_RANLIB

# There are known bugs when building the compiler in 64 bit mode on x86 so,
# unless the user specifies otherwise, we default to 32 bit mode as the
# default on x86 64 bit platforms.

if test "$host_alias" = "" && test "$host_cpu" = "x86_64"; then
  host_cpu=i686
  host=$host_cpu-$host_vendor-$host_os
fi

if test "$target_alias" = "" && test "$target_cpu" = "x86_64"; then
  target_cpu=i686
  target=$target_cpu-$target_vendor-$target_os
fi

AC_ARG_WITH(build-compiler,
[  --with-build-compiler=GNU|OSP	Use GNU or OSP compilers in build],
BUILD_COMPILER="$with_build_compiler",
BUILD_COMPILER=GNU)


# enable GASNet for Coarrays
AC_ARG_WITH(gasnet-root,
AS_HELP_STRING([--with-gasnet-root=<gasnet path>],
[Builds GASNet-based libcaf runtime]),
GASNET_HOME="$with_gasnet_root",
GASNET_HOME="")

# enable ARMCI for Coarrays
AC_ARG_WITH(armci-root,
AS_HELP_STRING([--with-armci-root=<armci path>],
[Builds ARMCI-based libcaf runtime]),
ARMCI_HOME="$with_armci_root",
ARMCI_HOME="")

# specify ARMCI network libs
AC_ARG_WITH(armci-network-libs,
AS_HELP_STRING([--with-armci-network-libs=<armci libs>],
[Specify additional network libraries for linker when using ARMCI]),
ARMCI_NETWORK_LIBS="$with_armci_network_libs",
ARMCI_NETWORK_LIBS="")

# enable SHMEM for Coarrays
AC_ARG_WITH(shmem-root,
AS_HELP_STRING([--with-shmem-root=<shmem path>],
[Builds SHMEM-based libcaf runtime]),
SHMEM_HOME="$with_shmem_root",
SHMEM_HOME="")

# specify SHMEM linker flags
AC_ARG_WITH(shmem-ldflags,
AS_HELP_STRING([--with-shmem-ldflags=<linker flags>],
[Specify additional flags for linker when using SHMEM]),
SHMEM_LDFLAGS="$with_shmem_ldflags",
SHMEM_LDFLAGS="")

# default comm library
AC_ARG_WITH(default-comm,
AS_HELP_STRING([--with-default-comm=gasnet|armci],
[Default communication layer to use if GASNet and ARMCI are supported.
 Will be GASNet if unspecified.]),
DEFAULT_COMM="$with_default_comm",
DEFAULT_COMM="")

# default CAF heap size
AC_ARG_WITH(default-caf-heap-size,
AS_HELP_STRING([--with-default-caf-heap-size=<heap size>],
[Default per-image heap size to use for coarray fortran programs. Can use
 suffixes K,M,G for kilobytes,megabytes,gigabytes respectively.
 Will be 30M if unspecified.]),
DEFAULT_CAF_HEAP_SIZE="$with_default_caf_heap_size",
DEFAULT_CAF_HEAP_SIZE="30M")

# default CAF teams heap size
AC_ARG_WITH(default-caf-teams-heap-size,
AS_HELP_STRING([--with-default-caf-teams-heap-size=<heap size>],
[Default per-image heap size to use for coarray fortran programs for
 coarray allocations within team. Can use suffixes K,M,G for kilobytes,megabytes,gigabytes respectively.
 Will be 10M if unspecified.]),
DEFAULT_CAF_TEAMS_HEAP_SIZE="$with_default_caf_teams_heap_size",
DEFAULT_CAF_TEAMS_HEAP_SIZE="10M")

# Set whether CAF runtime will be built with tracing
AC_ARG_ENABLE([cafrt-dtraces],
  AS_HELP_STRING([--enable-cafrt-dtraces],
                 [Enable CAF Runtime Diagnostic Tracing Functionality]),
                  CAFRT_ENABLE_DTRACES="YES")

AS_IF([test "x$enable_cafrt_dtraces" != "xyes"], [ CAFRT_ENABLE_DTRACES="NO" ])

# Set whether CAF runtime will be built
AC_ARG_ENABLE([cafrt-profiles],
  AS_HELP_STRING([--enable-cafrt-profiles],
                 [Enable CAF Runtime Profiling Functionality]),
                  CAFRT_ENABLE_PROFILES="YES")

AS_IF([test "x$enable_cafrt_profiles" != "xyes"], [ CAFRT_ENABLE_PROFILES="NO" ])

AC_ARG_WITH([epik],
AS_HELP_STRING([--with-epik=<path to EPIK>],
[Path to EPIK installation]),
EPIK_ROOT="$with_epik",
EPIK_ROOT="")

if test "${CAFRT_ENABLE_PROFILES}" = "NO" -a -n "${EPIK_ROOT}"; then
  AC_MSG_ERROR(
   [--with-epik= should be specified along with --enable-cafrt-profiles]
   )
fi


# set perl path
AC_PATH_PROG([BASH_PATH], [bash])

if test -z "${BASH_PATH}"; then
  AC_MSG_ERROR([Could not find bash on system])
fi

if test -z "${GASNET_HOME}" -a -z "${ARMCI_HOME}" -a -z "${SHMEM_HOME}"; then
    AC_MSG_ERROR([Either --with-gasnet-root=<path> or --with-armci-root=<path> or --with-shmem-root=<path> must be passed for coarrays])
fi

AC_PATH_PROG([MPICC_PATH], [mpicc])
if test ! -f "${UHCAF_MPI_INCLUDE}/mpi.h"; then
    UHCAF_MPI_INCLUDE=`dirname ${MPICC_PATH}`/../include
    if test ! -f "${UHCAF_MPI_INCLUDE}/mpi.h"; then
        AC_MSG_ERROR([Environment variable UHCAF_MPI_INCLUDE must be set to valid MPI include directory when enabling coarrays])
    else
        AC_MSG_NOTICE([Using $UHCAF_MPI_INCLUDE for compiling CAF runtime])
    fi
fi

if test -n "${ARMCI_HOME}"; then
    if test ! -d "${ARMCI_HOME}"; then
        AC_MSG_ERROR([Specified --with-armci-root=<path> does not look right.  Check path.])
    fi
fi

if test -n "${ARMCI_NETWORK_LIBS}" -a -z "${ARMCI_HOME}"; then
    AC_MSG_ERROR([--with-armci-root=<path> must be specified if you want to use ARMCI])
fi

if test -n "${GASNET_HOME}"; then
  GASNET_CONDUITS=`(cd ${GASNET_HOME}/include; echo *-conduit \
                    | sed 's/-conduit//g')`
   if test  "${GASNET_CONDUITS}" = "*"; then
      AC_MSG_ERROR([Specified --with-gasnet-root=<path> does not look right. Check path.])
   fi
fi

if test -n "${SHMEM_HOME}"; then
    if test ! -d "${SHMEM_HOME}"; then
        AC_MSG_ERROR([Specified --with-shmem-root=<path> does not look right.  Check path.])
    fi
fi

if test -n "${SHMEM_LDFLAGS}" -a -z "${SHMEM_HOME}"; then
    AC_MSG_ERROR([--with-shmem-root=<path> must be specified if you want to use SHMEM])
fi

if test -z "${DEFAULT_COMM}" -a -n "${GASNET_HOME}"; then
  DEFAULT_COMM=gasnet
elif test -z "${DEFAULT_COMM}" -a -n "${ARMCI_HOME}" ; then
  DEFAULT_COMM=armci
elif test -z "${DEFAULT_COMM}" -a -n "${SHMEM_HOME}" ; then
  DEFAULT_COMM=shmem
elif test -n "${DEFAULT_COMM}" -a "${DEFAULT_COMM}" != "gasnet"  -a "${DEFAULT_COMM}" != "armci" ; then
    AC_MSG_ERROR([--with-default-comm accepts gasnet or armci])
elif test "${DEFAULT_COMM}" = "gasnet" -a -z "${GASNET_HOME}" ; then
    AC_MSG_ERROR([default comm (gasnet) requires --with-gasnet-root to be specified])
elif test "${DEFAULT_COMM}" = "armci" -a -z "${ARMCI_HOME}" ; then
    AC_MSG_ERROR([default comm (armci) requires --with-armci-root to be specified])
elif test "${DEFAULT_COMM}" = "shmem" -a -z "${SHMEM_HOME}" ; then
    AC_MSG_ERROR([default comm (shmem) requires --with-shmem-root to be specified])
fi

if test -z "${DEFAULT_CAF_HEAP_SIZE}"; then
    AC_MSG_ERROR([Invalid value for --with-default-caf-heap-size. Should be an
                 integer, optionally followed by k, K, m, M, g, or G.])
elif test `echo ${DEFAULT_CAF_HEAP_SIZE} | grep ^@<:@0-9@:>@@<:@0-9@:>@*$ | wc -l` = 0  -a \
       `echo ${DEFAULT_CAF_HEAP_SIZE} | grep ^@<:@0-9@:>@@<:@0-9@:>@*@<:@kKmMgG@:>@$ | wc -l` = 0; then
      AC_MSG_ERROR([Invalid value for --with-default-caf-heap-size. Should be
                   an integer, optionally followed by k, K, m, M, g, or G.])
fi

if test -z "${DEFAULT_CAF_TEAMS_HEAP_SIZE}"; then
    AC_MSG_ERROR([Invalid value for --with-default-caf-teams-heap-size. Should be an
                 integer, optionally followed by k, K, m, M, g, or G.])
elif test `echo ${DEFAULT_CAF_TEAMS_HEAP_SIZE} | grep ^@<:@0-9@:>@@<:@0-9@:>@*$ | wc -l` = 0  -a \
       `echo ${DEFAULT_CAF_TEAMS_HEAP_SIZE} | grep ^@<:@0-9@:>@@<:@0-9@:>@*@<:@kKmMgG@:>@$ | wc -l` = 0; then
      AC_MSG_ERROR([Invalid value for --with-default-caf-teams-heap-size. Should be
                   an integer, optionally followed by k, K, m, M, g, or G.])
fi

base_path=`case $0 in /*) echo "$0";; *) echo "$PWD/$0";; esac`
base_path=`dirname $base_path`
OPENUH_VERSION=`echo "echo \\\$OPENUH_FULL_VERSION" | cat $base_path/defs.mk - | sh -`

case "$BUILD_COMPILER" in
  GNU|gnu|gcc)
    BUILD_COMPILER=GNU
    GCC_CONFIGURE_COMPILER=gcc
    CYGNUS_CONFIGURE_COMPILER=gcc
    ;;
  OSP|osp|opencc|open64)
    BUILD_COMPILER=OSP
    GCC_CONFIGURE_COMPILER=opencc
    CYGNUS_CONFIGURE_COMPILER=opencc
    ;;
  *)
    AC_MSG_ERROR(["BUILD_COMPILER=$BUILD_COMPILER is not supported"])
    ;;
esac

AC_ARG_WITH(build-optimize,
[  --with-build-optimize=DEFAULT|DEBUG	Use DEFAULT or DEBUG flags in compiler build],
BUILD_OPTIMIZE="$with_build_optimize",
BUILD_OPTIMIZE=DEFAULT)

case "$BUILD_OPTIMIZE" in
  DEFAULT|default)
    BUILD_OPTIMIZE=DEFAULT
    GCC_CONFIGURE_CFLAGS="-O2"
    ;;
  DEBUG|debug)
    BUILD_OPTIMIZE=DEBUG
    GCC_CONFIGURE_CFLAGS="-O0 -g -DIs_True_On"
    ;;
  *)
    AC_MSG_ERROR(["BUILD_OPTIMIZE=$BUILD_OPTIMIZE is not supported"])
    ;;
esac

AC_ARG_WITH(build-lib-optimize,
[  --with-build-lib-optimize=DEFAULT|DEBUG Use DEFAULT or DEBUG flags in library build.
    Note that --with-build-lib-optimize=DEBUG is currently not well tested.],
BUILD_LIB_OPTIMIZE="$with_build_lib_optimize",
BUILD_LIB_OPTIMIZE=DEFAULT)

case "$BUILD_LIB_OPTIMIZE" in
  DEFAULT|default)
    BUILD_LIB_OPTIMIZE=DEFAULT
    ;;
  DEBUG|debug)
    BUILD_LIB_OPTIMIZE=DEBUG
    ;;
  *)
    AC_MSG_ERROR(["BUILD_LIB_OPTIMIZE=$BUILD_LIB_OPTIMIZE is not supported"])
    ;;
esac

# BUILD_MULTILIB supports building libraries twice, this is used on x86
# targets to have 32 and 64 bit libraries available.
BUILD_MULTILIB=NO

# BUILD_BOTH is (only) used in osprey/Makefile.gsetup.in for setting -fPIC.
BUILD_BOTH=


# Set whether shared libraries will be built.  Implies --disable-ipa.
BUILD_TYPE=NONSHARED
AC_ARG_ENABLE([shared],
  AS_HELP_STRING([--disable-shared], [Disable shared libraries (EXPERIMENTAL)]))

AS_IF([test "x$enable_shared" != "xno"], [
  BUILD_TYPE=SHARED
])

if test "${BUILD_TYPE}" = "NONSHARED"; then
  BUILD_SKIP_IPA=YES
fi


# LIB_* and LIB2_* variables will default to the BUILD_* variables if not
# overridden in one of the case statements below so most platforms will
# not have to set these.
LIB_MACHINE_TYPE=
LIB_BUILD_TARGET=
LIB_BUILD_ABI=
LIB_BUILD_ARCH=
LIB_BUILD_HOST=
LIB2_MACHINE_TYPE=
LIB2_BUILD_TARGET=
LIB2_BUILD_ABI=
LIB2_BUILD_ARCH=
LIB2_BUILD_HOST=

# Set variables based on the host machine that the compiler will run on.
case "$host" in
	x86_64*-*-linux*)
		BUILD_ABI=I64BIT
		BUILD_ARCH=X8664
		BUILD_HOST=X8664
		CYGNUS_CONFIGURE_HOST=i686-open64-linux
		GCC_CONFIGURE_HOST=x86_64-redhat-linux
		;;
	i*86*-*-linux*)
		BUILD_ABI=I32BIT
		BUILD_ARCH=IA32
		BUILD_HOST=IA32
		CYGNUS_CONFIGURE_HOST=i686-open64-linux
		GCC_CONFIGURE_HOST=x86_64-redhat-linux
		;;
	ia64*-*-linux*)
		BUILD_ABI=I64BIT
		BUILD_ARCH=IA64
		BUILD_HOST=IA64
		CYGNUS_CONFIGURE_HOST=ia64-linux-gnu
		GCC_CONFIGURE_HOST=ia64-redhat-linux
		;;
	*)
		AC_MSG_ERROR(["open64 is not supported on $target"])
		;;
esac

CYGNUS_CONFIGURE_CFLAGS=
BUILD_VENDOR=

# Set variables based on the target machine that the compiler will generate
# code for.
case "$target" in
	x86_64*-*-linux*)
		MACHINE_TYPE=x86_64
		BUILD_TARGET=X8664
		LIB_MACHINE_TYPE=IA32
		LIB_BUILD_TARGET=IA32
		LIB_BUILD_ABI=I32BIT
		LIB_BUILD_ARCH=IA32
		LIB2_MACHINE_TYPE=X86_64
		LIB2_BUILD_TARGET=X8664
		LIB2_BUILD_ABI=I64BIT
		LIB2_BUILD_ARCH=X8664
		CYGNUS_CONFIGURE_TARG=x86_64-open64-linux
		GCC_CONFIGURE_TARG=x86_64-redhat-linux
		GCC_CONFIGURE_COMPILER+=" -m64"
		GCC_CONFIGURE_CFLAGS+=" -DTARG_X8664"
		;;
	i*86*-*-linux*)
		MACHINE_TYPE=i386
		BUILD_TARGET=X8664
		LIB_MACHINE_TYPE=IA32
		LIB_BUILD_TARGET=IA32
		LIB_BUILD_ABI=I32BIT
		LIB_BUILD_ARCH=IA32
		LIB2_MACHINE_TYPE=X86_64
		LIB2_BUILD_TARGET=X8664
		LIB2_BUILD_ABI=I64BIT
		LIB2_BUILD_ARCH=X8664
		CYGNUS_CONFIGURE_TARG=x86_64-open64-linux
		GCC_CONFIGURE_TARG=x86_64-redhat-linux
		GCC_CONFIGURE_COMPILER+=" -m32"
		GCC_CONFIGURE_CFLAGS+=" -DTARG_X8664"
		CYGNUS_CONFIGURE_CFLAGS="-m32"
		;;
	ia64*-*-linux*)
		MACHINE_TYPE=ia64
		BUILD_TARGET=IA64
		CYGNUS_CONFIGURE_TARG=ia64-linux-gnu
		GCC_CONFIGURE_TARG=ia64-redhat-linux
		GCC_CONFIGURE_CFLAGS+=" -DTARG_IA64"
		TARG_INFO_NAME=ipfec_targ_info
		;;
	sl*-*-linux*)
		MACHINE_TYPE=SL
		BUILD_TARGET=SL
		BUILD_ABI=N32BIT
		BUILD_ARCH=MIPS4
		BUILD_VENDOR=SL
		CYGNUS_CONFIGURE_HOST=i686-gnu-linux
		GCC_CONFIGURE_HOST=mips-redhat-linux
		CYGNUS_CONFIGURE_TARG=mipsel-elf-linux
		GCC_CONFIGURE_TARG=mips-redhat-linux
		GCC_CONFIGURE_CFLAGS+=" -m32 -DTARG_SL"
		CYGNUS_CONFIGURE_CFLAGS=" -m32"
		BUILD_MULTILIB=NO
		;;
	*)
		AC_MSG_ERROR(["open64 is not supported on $target"])
		;;
esac

UNAME_MACHINE=`uname -m`
if test "$UNAME_MACHINE" = "x86_64"; then
   BUILD_MULTILIB=YES
fi
# Set default values for LIB_* and LIB2_* variables that were not set above.
if test "$LIB_MACHINE_TYPE" = ""; then
  LIB_MACHINE_TYPE=$MACHINE_TYPE
fi
if test "$LIB_BUILD_TARGET" = ""; then
  LIB_BUILD_TARGET=$BUILD_TARGET
fi
if test "$LIB_BUILD_ABI" = ""; then
  LIB_BUILD_ABI=$BUILD_ABI
fi
if test "$LIB_BUILD_ARCH" = ""; then
  LIB_BUILD_ARCH=$BUILD_ARCH
fi
if test "$LIB_BUILD_HOST" = ""; then
  LIB_BUILD_HOST=$BUILD_HOST
fi

if test "$LIB2_MACHINE_TYPE" = ""; then
  LIB2_MACHINE_TYPE=$MACHINE_TYPE
fi
if test "$LIB2_BUILD_TARGET" = ""; then
  LIB2_BUILD_TARGET=$BUILD_TARGET
fi
if test "$LIB2_BUILD_ABI" = ""; then
  LIB2_BUILD_ABI=$BUILD_ABI
fi
if test "$LIB2_BUILD_ARCH" = ""; then
  LIB2_BUILD_ARCH=$BUILD_ARCH
fi
if test "$LIB2_BUILD_HOST" = ""; then
  LIB2_BUILD_HOST=$BUILD_HOST
fi

# Export these variables so they can be used in the 'subconfigures run in
# osprey/cygnus and osprey-gcc-4.2.0.
export CYGNUS_CONFIGURE_COMPILER
export CYGNUS_CONFIGURE_HOST
export CYGNUS_CONFIGURE_TARG
export CYGNUS_CONFIGURE_CFLAGS
export GCC_CONFIGURE_COMPILER
export GCC_CONFIGURE_HOST
export GCC_CONFIGURE_TARG
export GCC_CONFIGURE_CFLAGS

# Variables to replace in the configurable files.
AC_SUBST([MACHINE_TYPE])
AC_SUBST([BUILD_ABI])
AC_SUBST([BUILD_ARCH])
AC_SUBST([BUILD_HOST])
AC_SUBST([BUILD_TARGET])
AC_SUBST([BUILD_VENDOR])
AC_SUBST([BUILD_OPTIMIZE])
AC_SUBST([BUILD_LIB_OPTIMIZE])
AC_SUBST([BUILD_COMPILER])
AC_SUBST([BUILD_BOTH])
AC_SUBST([LIB_MACHINE_TYPE])
AC_SUBST([LIB_BUILD_TARGET])
AC_SUBST([LIB_BUILD_ABI])
AC_SUBST([LIB_BUILD_ARCH])
AC_SUBST([LIB_BUILD_HOST])
AC_SUBST([LIB2_MACHINE_TYPE])
AC_SUBST([LIB2_BUILD_TARGET])
AC_SUBST([LIB2_BUILD_ABI])
AC_SUBST([LIB2_BUILD_ARCH])
AC_SUBST([LIB2_BUILD_HOST])
AC_SUBST([BUILD_MULTILIB])
AC_SUBST([COMPILER_TARG_DIR])
AC_SUBST([TARG_INFO_NAME])
AC_SUBST([BUILD_TYPE])
AC_SUBST([GASNET_HOME])
AC_SUBST([ARMCI_HOME])
AC_SUBST([ARMCI_NETWORK_LIBS])
AC_SUBST([GASNET_CONDUITS])
AC_SUBST([SHMEM_HOME])
AC_SUBST([SHMEM_LDFLAGS])
AC_SUBST([DEFAULT_COMM])
AC_SUBST([UHCAF_MPI_INCLUDE])
AC_SUBST([UHCAF_MPI_FCFLAGS])
AC_SUBST([UHCAF_MPI_LDFLAGS])
AC_SUBST([CAFRT_ENABLE_DTRACES])
AC_SUBST([CAFRT_ENABLE_PROFILES])
AC_SUBST([DEFAULT_CAF_HEAP_SIZE])
AC_SUBST([DEFAULT_CAF_TEAMS_HEAP_SIZE])
AC_SUBST([EPIK_ROOT])
AC_SUBST([OPENUH_VERSION])

# List of configurable files to create in object directory.
AC_CONFIG_FILES([
  Makefile
  osprey/Makefile.gsetup
])

AC_CONFIG_FILES([
  osprey/scripts/uhcaf
  osprey/scripts/cafrun
])

# The directories created under targdir_lib (and targdir_lib2) also
# need to be listed in LIBLIST.  This list is used in targdir_lib/Makefile.in
# to control the order of the library builds.  When adding a directory
# under targdir_lib you need to add it to AC_CONFIG_FILES and add it to
# LIBLIST.

if test "${BUILD_TARGET}" = "SL"; then
  LIBLIST=""
else
  LIBLIST="libcaf"
fi

AC_CONFIG_FILES([
  osprey/targdir_lib/Makefile
])

AC_CONFIG_FILES([
 osprey/targdir_lib/libcaf/Makefile
 osprey/targdir_lib/libcaf/armci/Makefile
 osprey/targdir_lib/libcaf/shmem/Makefile
])
 if test -n "${GASNET_CONDUITS}"; then
   for conduit in $GASNET_CONDUITS; do
     AC_CONFIG_FILES([
     osprey/targdir_lib/libcaf/gasnet-${conduit}/Makefile:osprey/targdir_lib/libcaf/gasnet/Makefile.in
     ])
   done
 else
     AC_CONFIG_FILES([
     osprey/targdir_lib/libcaf/gasnet/Makefile
     ])
 fi

if test "${BUILD_TARGET}" = "IA64" ; then
  LIBLIST="$LIBLIST init"
  AC_CONFIG_FILES([
    osprey/targdir_lib/init/Makefile:osprey/targdir_lib/init/Makefile.in
  ])
fi   

if test $BUILD_MULTILIB = "YES"; then
  AC_CONFIG_FILES([
    osprey/targdir_lib2/Makefile:osprey/targdir_lib/Makefile.in
  ])
    AC_CONFIG_FILES([
    osprey/targdir_lib2/libcaf/Makefile:osprey/targdir_lib/libcaf/Makefile.in
    osprey/targdir_lib2/libcaf/armci/Makefile:osprey/targdir_lib/libcaf/armci/Makefile.in
    osprey/targdir_lib2/libcaf/shmem/Makefile:osprey/targdir_lib/libcaf/shmem/Makefile.in
  ])
  if test -n "${GASNET_CONDUITS}"; then
    for conduit in $GASNET_CONDUITS; do
      AC_CONFIG_FILES([
      osprey/targdir_lib2/libcaf/gasnet-${conduit}/Makefile:osprey/targdir_lib/libcaf/gasnet/Makefile.in
      ])
    done
  else
      AC_CONFIG_FILES([
      osprey/targdir_lib2/libcaf/gasnet/Makefile:osprey/targdir_lib/libcaf/gasnet/Makefile.in
      ])
  fi
fi

AC_SUBST([LIBLIST])

AC_OUTPUT

# -----------------------
# Final Configure Report
# -----------------------
AC_MSG_NOTICE([])
AC_MSG_NOTICE([********************************************************************])
AC_MSG_NOTICE([                   OPENUH CAF RUNTIME CONFIGURATION])
AC_MSG_NOTICE([********************************************************************])
AC_MSG_NOTICE([])
AC_MSG_NOTICE([   OPENUH_VERSION                 = $OPENUH_VERSION])
AC_MSG_NOTICE([   INSTALLATION PATH              = $prefix])
AC_MSG_NOTICE([   HOST                           = $host])
AC_MSG_NOTICE([   TARGET                         = $target])
AC_MSG_NOTICE([   BUILD_COMPILER                 = $BUILD_COMPILER])
AC_MSG_NOTICE([   BUILD_LIB_OPTIMIZE             = $BUILD_LIB_OPTIMIZE])
AC_MSG_NOTICE([   CAFRT_ENABLE_DTRACES           = $CAFRT_ENABLE_DTRACES])
AC_MSG_NOTICE([   CAFRT_ENABLE_PROFILES          = $CAFRT_ENABLE_PROFILES])
AS_IF([test "${CAFRT_ENABLE_PROFILES}" = "YES"], [
AC_MSG_NOTICE([   EPIK_ROOT                      = $EPIK_ROOT])
])
AC_MSG_NOTICE([   DEFAULT_CAF_HEAP_SIZE          = $DEFAULT_CAF_HEAP_SIZE])
AC_MSG_NOTICE([   DEFAULT_CAF_TEAMS_HEAP_SIZE    = $DEFAULT_CAF_TEAMS_HEAP_SIZE])
AC_MSG_NOTICE([   DEFAULT_COMM                   = $DEFAULT_COMM])
AC_MSG_NOTICE([   GASNET_HOME                    = $GASNET_HOME])
AC_MSG_NOTICE([   GASNET_CONDUITS                = $GASNET_CONDUITS])
AC_MSG_NOTICE([   ARMCI_HOME                     = $ARMCI_HOME])
AC_MSG_NOTICE([   ARMCI_NETWORK_LIBS             = $ARMCI_NETWORK_LIBS])
AC_MSG_NOTICE([   SHMEM_HOME                     = $SHMEM_HOME])
AC_MSG_NOTICE([   SHMEM_LDFLAGS                  = $SHMEM_LDFLAGS])
AC_MSG_NOTICE([   UHCAF_MPI_INCLUDE              = $UHCAF_MPI_INCLUDE])
AC_MSG_NOTICE([   UHCAF_MPI_FCFLAGS              = $UHCAF_MPI_FCFLAGS])
AC_MSG_NOTICE([   UHCAF_MPI_LDFLAGS              = $UHCAF_MPI_LDFLAGS])
AC_MSG_NOTICE([])
AC_MSG_NOTICE([********************************************************************])
AC_MSG_NOTICE([])
