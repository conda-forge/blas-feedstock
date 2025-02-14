#!/bin/bash

mkdir build
cd build

export NEW_ENV=`pwd`/_env
export LIBRARY_PREFIX=$NEW_ENV

export FFLAGS="-I${LIBRARY_PREFIX}/include $FFLAGS"
export LDFLAGS="-L${LIBRARY_PREFIX}/lib -Wl,-rpath,${LIBRARY_PREFIX}/lib $LDFLAGS"

export CPATH="${LIBRARY_PREFIX}/include"
export LIBRARY_PATH="${LIBRARY_PREFIX}/lib"

extra_deps=""
if [[ "$blas_impl" == "mkl" ]]; then
    extra_deps="mkl-devel=${mkl}"
fi

export CONDA_SUBDIR="${target_platform}"
conda create -p ${NEW_ENV} -c conda-forge --yes --quiet \
    libblas=${PKG_VERSION}=*netlib \
    libcblas=${PKG_VERSION}=*netlib \
    liblapack=${PKG_VERSION}=*netlib \
    liblapacke=${PKG_VERSION}=*netlib \
    ${extra_deps} \
    ${fortran_compiler}_${target_platform}=${fortran_compiler_version}
unset CONDA_SUBDIR

# Link against the netlib libraries
cmake ${CMAKE_ARGS} -LAH -G "${CMAKE_GENERATOR}" .. \
    "-DBLAS_LIBRARIES=libblas${SHLIB_EXT};libcblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=liblapack${SHLIB_EXT};liblapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH=${NEW_ENV} \
    || (cat $SRC_DIR/build/CMakeFiles/CMakeError.log && $SRC_DIR/build/CMakeFiles/CMakeOutput.log && false)

cmake --build . --config Release

if [[ "$blas_impl" == "accelerate" ]]; then
    mkdir -p $SRC_DIR/accelerate
    cp $NEW_ENV/lib/liblapack.dylib $SRC_DIR/accelerate/liblapack-netlib.${PKG_VERSION}.dylib
    cp $NEW_ENV/lib/liblapacke.dylib $SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib
    $INSTALL_NAME_TOOL -id "@rpath/liblapack-netlib.${PKG_VERSION}.dylib" $SRC_DIR/accelerate/liblapack-netlib.${PKG_VERSION}.dylib
    $INSTALL_NAME_TOOL -id "@rpath/liblapacke-netlib.${PKG_VERSION}.dylib" $SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib

    veclib_loc=$SDKROOT/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A
    if [[ -f ${veclib_loc}/libBLAS.dylib ]]; then
        veclib_libblas="${veclib_loc}/libBLAS.dylib"
    else
        veclib_libblas="${veclib_loc}/libBLAS.tbd"
    fi

    export LDFLAGS="${LDFLAGS/-Wl,-dead_strip_dylibs/}"

    $CC ${CFLAGS} -O3 -c -o vecLibFort.o $SRC_DIR/vecLibFort/vecLibFort.c
    $CC -shared -o libvecLibFort-ng.dylib \
        vecLibFort.o \
        ${LDFLAGS} \
        -Wl,-reexport_library,${veclib_libblas} \
        -Wl,-reexport_library,$SRC_DIR/accelerate/liblapack-netlib.${PKG_VERSION}.dylib \
        -Wl,-reexport_library,$SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib

    cp libvecLibFort-ng.dylib $SRC_DIR/accelerate/
fi

rm -rf ${NEW_ENV}
