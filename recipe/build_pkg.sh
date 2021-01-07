if [[ "${blas_impl}" == "mkl" ]]; then
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/libblas_mkl_${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/libblas_mkl_${CHANGE}.sh"
    done
elif [[ "${blas_impl}" == "blis" ]]; then
    # blis does not package liblapack(e); repack netlib-variant
    if [[ "${PKG_NAME}" == "liblapack" || "${PKG_NAME}" == "liblapacke"  ]]; then
        export NEW_ENV=`pwd`/_env
        export CONDA_SUBDIR="${target_platform}"
        conda create -p ${NEW_ENV} -c conda-forge --yes --quiet \
            liblapack=${PKG_VERSION}=*netlib \
            liblapacke=${PKG_VERSION}=*netlib
        unset CONDA_SUBDIR
        # copy once...
        cp $NEW_ENV/lib/${PKG_NAME}${SHLIB_EXT} $PREFIX/lib/${PKG_NAME}${SHLIB_EXT}
        # ... link the other
        if [[ "$target_platform" == osx-* ]]; then
            ln -s $PREFIX/lib/${PKG_NAME}${SHLIB_EXT} $PREFIX/lib/${PKG_NAME}.${PKG_VERSION:0:1}.dylib
        else
            ln -s $PREFIX/lib/${PKG_NAME}${SHLIB_EXT} $PREFIX/lib/${PKG_NAME}.so.${PKG_VERSION:0:1}
        fi
        # cut short the rest of the script
        exit 0
    fi
fi

if [[ "$target_platform" == osx-* ]]; then
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.${PKG_VERSION:0:1}.dylib
else
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.so.${PKG_VERSION:0:1}
fi
ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}${SHLIB_EXT}
