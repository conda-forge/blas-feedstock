if [[ "$(uname)" == "Darwin" ]]; then
    ln -s $PREFIX/lib/lib${blas_impl_lib}.dylib $PREFIX/lib/${PKG_NAME}.${PKG_VERSION:0:1}.dylib
else
    ln -s $PREFIX/lib/lib${blas_impl_lib}.so $PREFIX/lib/${PKG_NAME}.so.${PKG_VERSION:0:1}
fi

