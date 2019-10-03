if [[ "$target_platform" == "osx-64" ]]; then
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.${PKG_VERSION:0:1}.dylib
else
    ln -s $PREFIX/lib/${blas_impl_lib} $PREFIX/lib/${PKG_NAME}.so.${PKG_VERSION:0:1}
fi

if [[ "${blas_impl}" == "mkl" ]]; then
    for CHANGE in "activate" "deactivate"
    do
        mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
        cp "${RECIPE_DIR}/libblas_mkl_${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/libblas_mkl_${CHANGE}.sh"
    done
fi
