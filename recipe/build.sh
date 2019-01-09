#!/bin/bash
set +e

mkdir build
cd build

ls -al ${PREFIX}/lib
ls -al ${PREFIX}/include

export CPATH="${PREFIX}/include"
export LIBRARY_PATH="${PREFIX}/lib"

if [[ "$(uname)" == "Linux" || "$(uname)" == "Darwin" ]]; then
    export SHLIB_PREFIX=lib
fi

# Link against the netlib libraries
cmake -G "${CMAKE_GENERATOR}" .. \
    "-DBLAS_LIBRARIES=${PREFIX}/lib/${SHLIB_PREFIX}blas${SHLIB_EXT};${PREFIX}/lib/${SHLIB_PREFIX}cblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=${PREFIX}/lib/${SHLIB_PREFIX}lapack${SHLIB_EXT};${PREFIX}/lib/${SHLIB_PREFIX}lapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release

cat CMakeFiles/CMakeOutput.log CMakeFiles/CMakeError.log

make -j${CPU_COUNT}

