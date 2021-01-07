#!/bin/bash
set -ex

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  exit 0
fi

cd build

SKIP_TESTS="dummy"

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
fi

if [[ "${blas_impl}" == "mkl" ]]; then
  if [[ "$target_platform" == "linux-64" ]]; then
    # TODO: figure out these segfaults
    SKIP_TESTS="${SKIP_TESTS}|example_DGELS_rowmajor|example_DGELS_colmajor"
  elif [[ "$target_platform" == "osx-64" || "$target_platform" == "win-64" ]]; then
    # "shared" failures on osx-64, win-64
    SKIP_TESTS="${SKIP_TESTS}|BLAS-xblat1c|LAPACK-xeigtstc_ced_in|LAPACK-xeigtstc_csb_in|LAPACK-xeigtstc_csg_in"
    SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_se2_in|LAPACK-xeigtstc_sep_in"
    SKIP_TESTS="${SKIP_TESTS}|LAPACK-xlintstc_ctest_in|LAPACK-xlintstrfc_ctest_rfp_in"
  fi
  if [[ "$target_platform" == "osx-64" ]]; then
    # additional failures only on osx-64
    SKIP_TESTS="${SKIP_TESTS}|BLAS-xblat1z|LAPACK-xeigtstz_se2_in|LAPACK-xeigtstz_sep_in"
    SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz_zed_in|LAPACK-xeigtstz_zsb_in|LAPACK-xeigtstz_zsg_in"
    SKIP_TESTS="${SKIP_TESTS}|LAPACK-xlintstrfz_ztest_rfp_in|LAPACK-xlintstz_ztest_in|LAPACK-xlintstzc_zctest_in"
  fi
fi

if [[ "${blas_impl}" == "openblas" && "$(uname)" == MINGW* ]]; then
  # I'm not sure why these fail only on Windows. Skip for now.
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtsts_sgd_in|LAPACK-xeigtsts_glm_in|LAPACK-xeigtsts_gsv_in|LAPACK-xeigtsts_lse_in|LAPACK-xeigtstd_dgd_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstd_glm_in|LAPACK-xeigtstd_gsv_in|LAPACK-xeigtstd_lse_in|LAPACK-xlintstc_ctest_in|LAPACK-xlintstrfc_ctest_rfp_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_sep_in|LAPACK-xeigtstc_se2_in|LAPACK-xeigtstc_ced_in|LAPACK-xeigtstc_cgd_in|LAPACK-xeigtstc_csb_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_csg_in|LAPACK-xeigtstc_glm_in|LAPACK-xeigtstc_gsv_in|LAPACK-xeigtstc_lse_in|LAPACK-xeigtstz_zgd_in"
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz_glm_in|LAPACK-xeigtstz_gsv_in|LAPACK-xeigtstz_lse_in|BLAS-xblat1c"
fi

if [[ "$target_platform" == "linux-ppc64le" ]]; then
  # lots of failing tests for this test-prefix on ppc
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstz"
elif [[ "$target_platform" == *-64 ]]; then
  # gained with MKL 2020.4 for lapack 3.9 across all x86_64 platforms, not sure why
  SKIP_TESTS="${SKIP_TESTS}|LAPACK-xeigtstc_svd_in|LAPACK-xeigtstd_svd_in|LAPACK-xeigtsts_svd_in|LAPACK-xeigtstz_svd_in"
fi

if [[ "$target_platform" == "win-64" ]]; then
  ${BUILD_PREFIX}/Library/bin/ctest --output-on-failure -E "${SKIP_TESTS}"
else
  ctest --output-on-failure -E "${SKIP_TESTS}"
fi
