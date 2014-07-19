#!/bin/bash
#
#  Copyright (C) 2011-2013 University of Houston.
#
#  Copyright (C) 2008-2010 Advanced Micro Devices, Inc.  All Rights Reserved.
#
#  Copyright (C) 2000 Silicon Graphics, Inc.  All Rights Reserved.
#
#  This program is free software; you can redistribute it and/or modify it
#  under the terms of version 2 of the GNU General Public License as
#  published by the Free Software Foundation.
#
#  This program is distributed in the hope that it would be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#
#  Further, this software is distributed without any warranty that it is
#  free of the rightful claim of any third person regarding infringement 
#  or the like.  Any license provided herein, whether implied or 
#  otherwise, applies only to this software file.  Patent licenses, if 
#  any, provided herein do not apply to combinations of this program with 
#  other software, or any other product whatsoever.  
#
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write the Free Software Foundation, Inc., 59
#  Temple Place - Suite 330, Boston MA 02111-1307, USA.
#
#  Contact information:  Silicon Graphics, Inc., 1600 Amphitheatre Pky,
#  Mountain View, CA 94043, or:
#
#  http://www.sgi.com
#
#  For further information regarding this notice, see:
#
#  http://oss.sgi.com/projects/GenInfo/NoticeExplan
#
#

VER_MAJOR="5"
VER_MINOR="0"
#PATCH_LEVEL=""
VERSION="${OPEN64_FULL_VERSION:-${VER_MAJOR}.${VER_MINOR}}"

PREBUILT_LIB="./lib"
PREBUILT_BIN="./bin"

# get the machine type
if [ -z "$1" ]; then
    ARCH=`uname -m | sed -e s/i.86/i386/`
else
    ARCH=$1
fi


# set the build host
case $ARCH in 
ia64 )
    BUILD_HOST="ia64"
    TARG_HOST="ia64"
    AREA="osprey/targia64_ia64_nodebug"
    PHASE_DIR_PREFIX="ia64"
    PREBUILD_INTERPOS="ia64-linux"
    INSTALL_TYPE="ia64-native"
    ;;
i386 )
    BUILD_HOST="ia32"
    TARG_HOST="x8664"
    PHASE_DIR_PREFIX="x86_64"
    PREBUILD_INTERPOS="x8664-linux"
    AREA="osprey/targia32_x8664"
    INSTALL_TYPE="x8664-native"
    ;;
x86_64 )
    BUILD_HOST="x8664"
    TARG_HOST="x8664"
    PHASE_DIR_PREFIX="x86_64"
    PREBUILD_INTERPOS="x8664-linux"
    AREA="osprey/targx8664_x8664"
    INSTALL_TYPE="x8664-native"
    ;;
ppc )
    BUILD_HOST="ppc32"
    TARG_HOST="ppc32"
    AREA="osprey/targppc32_ppc32"
    PHASE_DIR_PREFIX="ppc32"
    PREBUILD_INTERPOS="ppc32-linux"
    INSTALL_TYPE="ppc32-native"
    ;;
cross )
    BUILD_HOST="ia32"
    TARG_HOST="ia64"
    PHASE_DIR_PREFIX="ia64"
    PREBUILD_INTERPOS="ia32-linux"
    AREA="osprey/targia32_ia64_nodebug"
    INSTALL_TYPE="ia64-cross"
    ;;
*)
    echo "Error: Unsupport platform: $ARCH"
    exit 1
    ;;
esac

AREA="osprey/targdir"

# get the TOOLROOT
if [ -z ${TOOLROOT} ] ; then
    echo "NOTE: \$TOOLROOT is not set! You can either set \$TOOLROOT or specify an install directory."
    echo "INSTALL DIRECTORY:"
    read	# in $REPLY
    [ ! -d $REPLY ] && echo "$REPLY does not exist. Will create." && mkdir -p $REPLY
    [ ! -d $REPLY ] && echo "Can not create directory: $REPLY, exit." && exit 1
    ORIGIN_DIR=`pwd`
    cd $REPLY
    TOOLROOT=`pwd`
    cd $ORIGIN_DIR
    echo "INSTALL to $TOOLROOT"
fi 

# everything we will install is under $ROOT
ROOT=${TOOLROOT}/

# both targ_os and build_os are 'linux' so far
TARG_OS="linux"
BUILD_OS="linux"

# prepare the distination dir
INTERPOSE=
[ "$BUILD_HOST" = "$TARG_HOST" ] &&  INTERPOSE="" ; 
PHASEPATH=${ROOT}/${INTERPOSE}/lib/gcc-lib/${PHASE_DIR_PREFIX}-open64-linux/${VERSION}/
NATIVE_LIB_DIR=${PHASEPATH}
BIN_DIR=${ROOT}/${INTERPOSE}/bin
ALT_BIN_DIR=${ROOT}/${INTERPOSE}/altbin
# for omp.h etc. 
INC_DIR=${ROOT}/include

# install commands
INSTALL="/usr/bin/install -D"
INSTALL_DATA="/usr/bin/install -D -m 644"

INSTALL_EXEC_SUB () {

    [ $# -ne 2 ] && echo "!!!Component is missing, you probably need to install prebuilt binaries/archives" && return 1
    
    [ ! -e "$1" ] && echo "$1 does not exist" && return 1

    echo -e "$2 : $1 \n\t${INSTALL} $1 $2\n" | make -f - |\
    grep -v "Entering directory\|Leaving directory\|up to date"

    chmod +x $2  # ensures target is executable

    return 0;
}

INSTALL_DATA_SUB () {

    [ $# -ne 2 ] && echo "!!!Component is missing, you probably need to install prebuilt binaries/archives" && return 1

    [ ! -e "$1" ] && echo "$1 does not exist" && return 1

    echo -e "$2 : $1 \n\t${INSTALL_DATA} $1 $2\n" | make -f - |\
    grep -v "Entering directory\|Leaving directory\|up to date"

    return 0
}


# Install the CAF runtime library. If 
INSTALL_CAF_LIB () {
    #install uhcaf script
    INSTALL_EXEC_SUB osprey/scripts/uhcaf ${BIN_DIR}/uhcaf
    #install cafrun script
    INSTALL_EXEC_SUB osprey/scripts/cafrun ${BIN_DIR}/cafrun
    chmod +x ${BIN_DIR}/uhcaf ${BIN_DIR}/cafrun
    if [ "$TARG_HOST" = "ia64" ] ; then
	LIBAREA="osprey/targdir_lib"
        INSTALL_DATA_SUB ${LIBAREA}/libcaf/armci/libcaf-armci.a     ${PHASEPATH}/libcaf-armci.a
        INSTALL_DATA_SUB ${LIBAREA}/libcaf/armci/libcaf-armci.so.1 ${PHASEPATH}/libcaf-armci.so.1
        (cd ${PHASEPATH}; ln -sf libcaf-armci.so.1 libcaf-armci.so)
        gasnet_builds=`ls -d ${LIBAREA}/libcaf/gasnet-* 2> /dev/null`
        for gb in $gasnet_builds; do
          gasnet_conduit=`basename $gb | sed 's/gasnet-//'`
          lib_name=libcaf-gasnet-$gasnet_conduit
          INSTALL_DATA_SUB ${gb}/$lib_name.a   ${PHASEPATH}/$lib_name.a
          INSTALL_DATA_SUB ${gb}/$lib_name.so.1   ${PHASEPATH}/$lib_name.so.1
          (cd ${PHASEPATH}; ln -sf $lib_name.so.1 $lib_name.so)
        done
    elif [ "$TARG_HOST" = "ppc32" ] ; then
	LIBAREA="osprey/targdir_lib"
	LIB32AREA="osprey/targdir_lib2"
    else
	LIBAREA="osprey/targdir_lib2"
    LIB32AREA="osprey/targdir_lib"
        # 64bit libraries
        INSTALL_DATA_SUB ${LIBAREA}/libcaf/armci/libcaf-armci.a    ${PHASEPATH}/libcaf-armci.a
        INSTALL_DATA_SUB ${LIBAREA}/libcaf/armci/libcaf-armci.so.1 ${PHASEPATH}/libcaf-armci.so.1
        (cd ${PHASEPATH}; ln -sf libcaf-armci.so.1 libcaf-armci.so)
        gasnet_builds=`ls -d ${LIBAREA}/libcaf/gasnet-* 2> /dev/null`
        for gb in $gasnet_builds; do
          gasnet_conduit=`basename $gb | sed 's/gasnet-//'`
          lib_name=libcaf-gasnet-$gasnet_conduit
          INSTALL_DATA_SUB ${gb}/$lib_name.a   ${PHASEPATH}/$lib_name.a
          INSTALL_DATA_SUB ${gb}/$lib_name.so.1   ${PHASEPATH}/$lib_name.so.1
          (cd ${PHASEPATH}; ln -sf $lib_name.so.1 $lib_name.so)
        done

        # 32bit libraries
        INSTALL_DATA_SUB ${LIB32AREA}/libcaf/armci/libcaf-armci.a ${PHASEPATH}/32/libcaf-armci.a
        INSTALL_DATA_SUB ${LIB32AREA}/libcaf/armci/libcaf-armci.so.1 ${PHASEPATH}/32/libcaf-armci.so.1
        (cd ${PHASEPATH}/32; ln -sf libcaf-armci.so.1 libcaf-armci.so)
        gasnet_builds=`ls -d ${LIB32AREA}/libcaf/gasnet-* 2> /dev/null`
        for gb in $gasnet_builds; do
          gasnet_conduit=`basename $gb | sed 's/gasnet-//'`
          lib_name=libcaf-gasnet-$gasnet_conduit
          INSTALL_DATA_SUB ${gb}/$lib_name.a   ${PHASEPATH}/32/$lib_name.a
          INSTALL_DATA_SUB ${gb}/$lib_name.so.1 ${PHASEPATH}/32/$lib_name.so.1
          (cd ${PHASEPATH}/32; ln -sf $lib_name.so.1 $lib_name.so)
        done
  fi 
}

# cd `dirname $0`

[ ! -d ${BIN_DIR} ] && mkdir -p ${BIN_DIR}
[ ! -d ${NATIVE_LIB_DIR} ] && mkdir -p ${NATIVE_LIB_DIR}
if [ "$TARG_HOST" = "x8664" -a ! -d "${NATIVE_LIB_DIR}/32" ]; then
    mkdir -p ${NATIVE_LIB_DIR}/32
fi

# Install archieves 
INSTALL_CAF_LIB
exit 0
