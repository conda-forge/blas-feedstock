cd build

set "SKIP_TESTS=x*cblat2|x*cblat3"

if %blas_impl% == "mkl" (
  set "SKIP_TESTS=%SKIP_TESTS%|LAPACK-xeigtstz_sep_in|LAPACK-xeigtstz_zsb_in|LAPACK-xeigtstz_se2_in|LAPACK-xlintstrfz_ztest_rfp_in|LAPACK-xlintstz_ztest_in"
  set "SKIP_TESTS=%SKIP_TESTS%|LAPACK-xlintstc_ctest_in|LAPACK-xlintstrfc_ctest_rfp_in|LAPACK-xeigtstc_sep_in|LAPACK-xeigtstc_se2_in|LAPACK-xeigtstc_ced_in"
  set "SKIP_TESTS=%SKIP_TESTS%|LAPACK-xeigtstc_csb_in|LAPACK-xeigtstc_csg_in|LAPACK-xeigtstz_zed_in|LAPACK-xeigtstz_zsg_in|LAPACK-xlintstzc_zctest_in"
)

ctest --output-on-failure -E "%SKIP_TESTS%"
