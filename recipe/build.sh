#!/bin/bash
set +e

mkdir build
cd build

export NEW_ENV=`pwd`/_env

conda create -p ${NEW_ENV} --yes --quiet \
    libblas=${PKG_VERSION}=*netlib \
    libcblas=${PKG_VERSION}=*netlib \
    liblapack=${PKG_VERSION}=*netlib \
    liblapacke=${PKG_VERSION}=*netlib

ls -al ${PREFIX}/lib
ls -al ${PREFIX}/include

export CPATH="${NEW_ENV}/include"
export LIBRARY_PATH="${NEW_ENV}/lib"

if [[ "$(uname)" == "Linux" || "$(uname)" == "Darwin" ]]; then
    export SHLIB_PREFIX=lib
fi

# Link against the netlib libraries
cmake -G "${CMAKE_GENERATOR}" .. \
    "-DBLAS_LIBRARIES=${SHLIB_PREFIX}blas${SHLIB_EXT};${SHLIB_PREFIX}cblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=${SHLIB_PREFIX}lapack${SHLIB_EXT};${SHLIB_PREFIX}lapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release

cat CMakeFiles/CMakeOutput.log CMakeFiles/CMakeError.log

make -j${CPU_COUNT}

rm -rf ${NEW_ENV}
