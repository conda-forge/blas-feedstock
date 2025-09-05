if [[ "$blas_impl" == *"accelerate" && "${PKG_NAME}" == "libblas" ]]; then
    cp $SRC_DIR/accelerate/* $PREFIX/lib/
fi

# NVPL BLAS has separate entrypoints for BLAS and LAPACK
if [[ "$blas_impl" == "nvpl" ]]; then
    if [[ "${PKG_NAME}" == *"blas" ]]; then
        export blas_impl_lib=${blas_impl_lib%%,*}
    elif [[ "${PKG_NAME}" == "liblapack"* ]]; then
        export blas_impl_lib=${blas_impl_lib#*,}
    fi
fi

if [[ "$target_platform" == osx-* ]]; then
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.${PKG_VERSION:0:1}.dylib
else
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.so.${PKG_VERSION:0:1}
fi
ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}${SHLIB_EXT}

if [[ "${blas_impl}" == "mkl" ]]; then
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/libblas_mkl_${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/libblas_mkl_${CHANGE}.sh"
    done
fi
