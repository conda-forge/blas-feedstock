#!/bin/bash

mkdir build
cd build

export NEW_ENV=`pwd`/_env
if [[ "$(uname)" == "Linux" || "$(uname)" == "Darwin" ]]; then
    export SHLIB_PREFIX=lib
    export LIBRARY_PREFIX=$NEW_ENV
    export EXE_SUFFIX=""
else
    export LIBRARY_PREFIX=$NEW_ENV/Library
    export EXE_SUFFIX=".exe"
fi

conda${EXE_SUFFIX} create -p ${NEW_ENV} -c conda-forge --yes --quiet \
    libblas=${PKG_VERSION}=*netlib \
    libcblas=${PKG_VERSION}=*netlib \
    liblapack=${PKG_VERSION}=*netlib \
    liblapacke=${PKG_VERSION}=*netlib

export CPATH="${LIBRARY_PREFIX}/include"
export LIBRARY_PATH="${LIBRARY_PREFIX}/lib"

export FFLAGS="-I${LIBRARY_PREFIX}/include $FFLAGS"
export LDFLAGS="-L${LIBRARY_PREFIX}/lib $LDFLAGS"

# Link against the netlib libraries
cmake -G "${CMAKE_GENERATOR}" .. \
    "-DBLAS_LIBRARIES=${SHLIB_PREFIX}blas${SHLIB_EXT};${SHLIB_PREFIX}cblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=${SHLIB_PREFIX}lapack${SHLIB_EXT};${SHLIB_PREFIX}lapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release

make -j${CPU_COUNT}

rm -rf ${NEW_ENV}
