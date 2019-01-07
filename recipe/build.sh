#!/bin/bash
set -e

mkdir build
cd build

ls -al ${PREFIX}/lib

# Link against the netlib libraries
cmake .. \
    "-DBLAS_LIBRARIES=${PREFIX}/lib/libblas${SHLIB_EXT};${PREFIX}/lib/libcblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=${PREFIX}/lib/liblapack${SHLIB_EXT};${PREFIX}/lib/liblapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release 

cat CMakeFiles/CMakeOutput.log CMakeFiles/CMakeError.log

make -j${CPU_COUNT}

