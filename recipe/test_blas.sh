#!/bin/bash
set -ex

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  exit 0
fi

cd build

SKIP_TESTS="dummy"

if [[ "${blas_impl}" == "blis" ]]; then
  # conda-build can't install a correct environment for testing
  conda install -c conda-forge/label/lapack_rc -c conda-forge "libblas=*=*blis" "libcblas=*=*blis" "liblapack=*=*netlib" "liblapacke=*=*netlib" --use-local --yes -p $PREFIX
fi

if [[ "$target_platform" != osx-* ]]; then
  ulimit -s unlimited
fi

if [[ "$target_platform" == osx-* ]]; then
  # testing with shared libraries does not work. skip them.
  # to test that program exits if wrong parameters are given, what the testsuite
  # does is that the symbol xerbla (which logs the error and exits) is overriden
  # by the test program's own version which reports to the test program that
  # xerbla was called. This does not work with dylibs on osx and dlls on windows
  SKIP_TESTS="${SKIP_TESTS}|x*cblat2|x*cblat3"
  # Not sure why the following tests work with other blas implementations, but
  # they check error codes as well
  if [[ "${blas_impl}" == "accelerate" ]]; then
    SKIP_TESTS="${SKIP_TESTS}|xblat2*|xblat3*"
  fi
fi

if [[ "$target_platform" == "win-64" ]]; then
  ${BUILD_PREFIX}/Library/bin/ctest --output-on-failure -E "${SKIP_TESTS}"
else
  ctest --output-on-failure -E "${SKIP_TESTS}"
fi
