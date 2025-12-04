@echo on
setlocal enabledelayedexpansion

:: delete existing LLVM setup in image that often gets higher precedence, see
:: https://github.com/conda-forge/conda-forge-ci-setup-feedstock/pull/408
rmdir /s /q "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\Llvm"
rmdir /s /q "C:\Program Files\LLVM\bin"

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

set "PYTHON_EXEC=%BUILD_PREFIX%\python.exe"

%MINIFORGE_HOME%\Scripts\conda.exe create -p %NEW_ENV% --yes --quiet ^
    libblas=%PKG_VERSION%=*netlib ^
    libcblas=%PKG_VERSION%=*netlib ^
    liblapack=%PKG_VERSION%=*netlib ^
    liblapacke=%PKG_VERSION%=*netlib ^
    flang_win-64=%fortran_compiler_version%
if %ERRORLEVEL% neq 0 exit 1

:: default activation for clang-windows uses clang.exe, not clang-cl.exe, see
:: https://github.com/conda-forge/clang-win-activation-feedstock/pull/48
:: clang.exe cannot handle /LIBPATH: in LDFLAGS, but we need that for lld-link
set "CC=clang-cl.exe"

:: the list of allowed starting letters of the symbol is a crude way to filter out things like
:: fprintf, which should not have been exported in netlib libraries - probably a flang bug
set "FILTER=^[cdilsxzCRL]"

:: positional arguments are `create-forwarder-dll [input] [output]`; in our case, we have three libraries at play;
:: `input` is the netlib implementation in %NEW_ENV% which provides us the list of symbols we need to replicate
:: (modulo the filter above), `output` is the DLL forwarder we're creating, and the actual implementation of those
:: symbols (which we need to encode in the forwarder) is the `--implementing-dll-name` that varies per flavour
create-forwarder-dll "%NEW_ENV%\Library\bin\libblas.dll"  "%LIBRARY_BIN%\libblas.dll"  --implementing-dll-name=%blas_impl_lib% --no-temp-dir --symbol-filter-regex="%FILTER%"
if %ERRORLEVEL% neq 0 exit 1
create-forwarder-dll "%NEW_ENV%\Library\bin\libcblas.dll" "%LIBRARY_BIN%\libcblas.dll" --implementing-dll-name=%blas_impl_lib% --no-temp-dir --symbol-filter-regex="%FILTER%"
if %ERRORLEVEL% neq 0 exit 1
if not "%lapack_impl_lib%"=="notapplicable" (
    create-forwarder-dll "%NEW_ENV%\Library\bin\liblapack.dll"  "%LIBRARY_BIN%\liblapack.dll"  --implementing-dll-name=%lapack_impl_lib%  --no-temp-dir --symbol-filter-regex="%FILTER%"
    REM needs delayed expansion to work correctly
    if !ERRORLEVEL! neq 0 exit 1
    create-forwarder-dll "%NEW_ENV%\Library\bin\liblapacke.dll" "%LIBRARY_BIN%\liblapacke.dll" --implementing-dll-name=%lapack_impl_lib% --no-temp-dir --symbol-filter-regex="%FILTER%"
    if !ERRORLEVEL! neq 0 exit 1
)

:: Link against the netlib libraries
cmake -LAH -G Ninja .. ^
    "-DBLAS_LIBRARIES=blas.lib;cblas.lib" ^
    "-DLAPACK_LIBRARIES=lapack.lib;lapacke.lib" ^
    -DBUILD_TESTING=yes ^
    -DPYTHON_EXECUTABLE=%PYTHON_EXEC% ^
    -DCMAKE_BUILD_TYPE=Release
if %ERRORLEVEL% neq 0 (type .\CMakeFiles\CMakeError.log && type .\CMakeFiles\CMakeOutput.log && exit 1)

cmake --build . --config Release --parallel %CPU_COUNT%
if %ERRORLEVEL% neq 0 exit 1

rmdir /s /q %NEW_ENV%
