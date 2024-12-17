:: Trailing semicolon in this variable as set by current (2017/01)
:: conda-build breaks us. Manual fix:
set "MSYS2_ARG_CONV_EXCL=/AI;/AL;/OUT;/out"
copy "%RECIPE_DIR%\test_blas.sh" .
set CHERE_INVOKING=1
set "SHLIB_PREFIX="
bash -x "./test_blas.sh"
if errorlevel 1 exit 1
exit 0
