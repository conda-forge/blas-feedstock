#!/bin/bash

# Depending on our platform, shared libraries end with either .so or .dylib
if [[ `uname` == 'Darwin' ]]; then
     DYLIB_EXT=dylib
else
     DYLIB_EXT=so
fi

ln -s $PREFIX/lib/libopenblas.a $PREFIX/lib/libblas.a
ln -s $PREFIX/lib/libopenblas.a $PREFIX/lib/liblapack.a
ln -s $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/libblas.$DYLIB_EXT
ln -s $PREFIX/lib/libopenblas.$DYLIB_EXT $PREFIX/lib/liblapack.$DYLIB_EXT
