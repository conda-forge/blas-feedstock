@echo on
setlocal enabledelayedexpansion

mkdir build
cd build

set "NEW_ENV=%cd%\_env"

set "LIBRARY_PREFIX=%NEW_ENV%\Library"
:: For finding cmake (not in NEW_ENV but actual build env)
set "PATH=%PATH%:%BUILD_PREFIX%\Library\bin"

set "CPATH=%LIBRARY_PREFIX%\include"
set "LIBRARY_PATH==%LIBRARY_PREFIX%\lib"

set "CFLAGS=-I%LIBRARY_PREFIX%\include %CFLAGS%"
set "FFLAGS=-I%LIBRARY_PREFIX%\include %FFLAGS%"
set "LDFLAGS=/LIBPATH:%LIBRARY_PREFIX%\lib %LDFLAGS%"

set "extra_deps= "
if "%blas_impl%" == "mkl" (
    set "extra_deps=mkl-devel=%mkl%"
    set "LDFLAGS=%LDFLAGS% mkl_rt.lib"
)

%MINIFORGE_HOME%\Scripts\conda.exe create -p %NEW_ENV% -c conda-forge --yes --quiet ^
    libblas=%PKG_VERSION%=*netlib ^
    libcblas=%PKG_VERSION%=*netlib ^
    liblapack=%PKG_VERSION%=*netlib ^
    liblapacke=%PKG_VERSION%=*netlib ^
    flang_win-64=%fortran_compiler_version% ^
    !extra_deps!

:: default activation for clang-windows uses clang.exe, not clang-cl.exe, see
:: https://github.com/conda-forge/clang-win-activation-feedstock/pull/48
:: clang.exe cannot handle /LIBPATH: in LDFLAGS, but we need that for lld-link
set "CC=clang-cl.exe"

:: Link against the netlib libraries
cmake -LAH -G Ninja .. ^
    "-DBLAS_LIBRARIES=blas.lib;cblas.lib" ^
    "-DLAPACK_LIBRARIES=lapack.lib;lapacke.lib" ^
    -DBUILD_TESTING=yes ^
    -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (type .\CMakeFiles\CMakeError.log && type .\CMakeFiles\CMakeOutput.log && exit 1)

cmake --build . --config Release
if %ERRORLEVEL% neq 0 exit 1

rmdir /s /q %NEW_ENV%
