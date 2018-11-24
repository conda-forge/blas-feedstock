if [[ "${blas_impl}" == "mkl" ]]; then
    lib_impl="mkl_rt"
else
    lib_impl="${blas_impl}"
fi

for lib in blas cblas lapack lapacke; do
    if [[ $(uname) == "Darwin" ]]; then
        ln -s $PREFIX/lib/lib${lib_impl}.dylib $PREFIX/lib/lib$lib.3.dylib
    fi
    if [[ $(uname) == "Linux" ]]; then
        ln -s $PREFIX/lib/lib${lib_impl}.so $PREFIX/lib/lib$lib.so.3
    fi
done
