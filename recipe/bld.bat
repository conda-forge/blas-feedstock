:: Trailing semicolon in this variable as set by current (2017/01)
:: conda-build breaks us. Manual fix:
set "MSYS2_ARG_CONV_EXCL=/AI;/AL;/OUT;/out"
copy "%RECIPE_DIR%\build.sh" .
set "SHLIB_EXT=.lib"
set "CMAKE_GENERATOR=Ninja"
set CHERE_INVOKING=1
set "SHLIB_PREFIX="
set "fortran_compiler=flang"
set "fortran_compiler_version=19"
bash -x "./build.sh"
IF %ERRORLEVEL% NEQ 0 exit 1
exit 0
