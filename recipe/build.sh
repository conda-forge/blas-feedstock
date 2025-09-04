#!/bin/bash

mkdir build
cd build

export NEW_ENV=`pwd`/_env
export LIBRARY_PREFIX=$NEW_ENV

export FFLAGS="-I${LIBRARY_PREFIX}/include $FFLAGS"
export LDFLAGS="-L${LIBRARY_PREFIX}/lib -Wl,-rpath,${LIBRARY_PREFIX}/lib $LDFLAGS"

export CPATH="${LIBRARY_PREFIX}/include"
export LIBRARY_PATH="${LIBRARY_PREFIX}/lib"

export CONDA_SUBDIR="${target_platform}"
conda create -p ${NEW_ENV} -c conda-forge --yes --quiet \
    libblas=${PKG_VERSION}=*netlib \
    libcblas=${PKG_VERSION}=*netlib \
    liblapack=${PKG_VERSION}=*netlib \
    liblapacke=${PKG_VERSION}=*netlib \
    ${fortran_compiler}_${target_platform}=${fortran_compiler_version}
unset CONDA_SUBDIR

# Link against the netlib libraries
cmake ${CMAKE_ARGS} -LAH -G "${CMAKE_GENERATOR}" .. \
    "-DBLAS_LIBRARIES=libblas${SHLIB_EXT};libcblas${SHLIB_EXT}" \
    "-DLAPACK_LIBRARIES=liblapack${SHLIB_EXT};liblapacke${SHLIB_EXT}" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release \
    || (cat $SRC_DIR/build/CMakeFiles/CMakeError.log && $SRC_DIR/build/CMakeFiles/CMakeOutput.log && exit 1)

cmake --build . --config Release --parallel ${CPU_COUNT}

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

elif [[ "$blas_impl" == "newaccelerate" ]]; then
    # New Accelerate libraries have all symbols in BLAS, CBLAS, LAPACK with $NEWLAPACK
    # name appended to all the symbol names. Therefore we create a library that dispatches
    # eg: _dgemm -> _dgemm$NEWLAPACK with aliases.txt
    #
    # One exception to this is {c,z}dot{u,c}_ symbols which have different signatures.
    # We use wrap_accelerate.c to fix those.
    #
    # For LAPACKE symbols, we use the LAPACKE wrappers from netlib which will call
    # the LAPACK symbols from Accelerate.
    #
    # All of these are exported from libblas_reexport.dylib

    mkdir -p $SRC_DIR/accelerate
    cp $NEW_ENV/lib/liblapacke.dylib $SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib
    $INSTALL_NAME_TOOL -id "@rpath/liblapacke-netlib.${PKG_VERSION}.dylib" $SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib

    veclib_loc=$SDKROOT/System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A
    veclib_libblas="${veclib_loc}/libBLAS.tbd"
    veclib_liblapack="${veclib_loc}/libLAPACK.tbd"
    if [[ ! -f ${veclib_loc}/libLAPACK.tbd ]]; then
        echo "could not find TBD file ${veclib_loc}/libLAPACK.tbd"
	exit 1
    fi

    export LDFLAGS="${LDFLAGS/-Wl,-dead_strip_dylibs/}"

    for f in $veclib_libblas $veclib_liblapack; do
      symbols=$(cat $f | grep -o '[a-z0-9_]*$NEWLAPACK' | rev | cut -b 11- | rev | sort | uniq)
      for symbol in $symbols; do
        if [[ "$symbol" != "_appleblas"* && "$symbol" != "_catlas"* && "$symbol" != "roc" && "$symbol" != "_cdot"* && "$symbol" != "_zdot"* ]]; then
          echo $symbol'$NEWLAPACK' ${symbol} >> aliases.txt
          if [[ "$symbol" != "cblas"* ]]; then
            # Add _dgemm_ alias in addition to _dgemm
            echo $symbol'$NEWLAPACK' ${symbol}_ >> aliases.txt
          fi
        fi
      done
    done
    # These are defined in wrap_accelerate.c. Add a alias with the trailing underscore.
    # Leading underscore is because of C name mangling in macOS.
    echo _cdotu _cdotu_ >> aliases.txt
    echo _cdotc _cdotc_ >> aliases.txt
    echo _zdotu _zdotu_ >> aliases.txt
    echo _zdotc _zdotc_ >> aliases.txt
    echo _cladiv _cladiv_ >> aliases.txt
    echo _zladiv _zladiv_ >> aliases.txt
    cat aliases.txt

    $CC ${CFLAGS} -O3 -c -o wrap_accelerate.o ${RECIPE_DIR}/wrap_accelerate.c
    OBJECTS="wrap_accelerate.o"
    # These timing utility functions, lsame, dcabs1 are not in accelerate
    for utilf in INSTALL/second_INT_ETIME.f INSTALL/dsecnd_INT_ETIME.f BLAS/SRC/lsame.f BLAS/SRC/dcabs1.f SRC/xerbla_array.f; do
       $FC ${FFLAGS} -O3 -c ${SRC_DIR}/${utilf} -o util_$(basename ${utilf}).o
       OBJECTS="${OBJECTS} util_$(basename $utilf).o"
    done
    $CC -shared -o libblas_reexport.dylib \
        ${OBJECTS} \
        ${LDFLAGS} \
        -lgfortran \
        -Wl,-alias_list,${PWD}/aliases.txt \
        -Wl,-reexport_library,$SRC_DIR/accelerate/liblapacke-netlib.${PKG_VERSION}.dylib \
	-framework Accelerate

    cp libblas_reexport.dylib $SRC_DIR/accelerate/
fi

rm -rf ${NEW_ENV}
