@echo on

mkdir build
cd build

set "NEW_ENV=%cd%\_env"

set "LIBRARY_PREFIX=%NEW_ENV%\Library"
:: For finding cmake (not in NEW_ENV but actual build env)
set "PATH=%PATH%:%BUILD_PREFIX%\Library\bin"

set "CPATH=%LIBRARY_PREFIX%\include"
set "LIBRARY_PATH==%LIBRARY_PREFIX%\lib"

set "FFLAGS=-I%LIBRARY_PREFIX%\include %FFLAGS%"
set "LDFLAGS=-L%LIBRARY_PREFIX%\lib %LDFLAGS%"

%MINIFORGE_HOME%\Scripts\conda.exe create -p %NEW_ENV% -c conda-forge --yes --quiet ^
    libblas=%PKG_VERSION%=*netlib ^
    libcblas=%PKG_VERSION%=*netlib ^
    liblapack=%PKG_VERSION%=*netlib ^
    liblapacke=%PKG_VERSION%=*netlib ^
    flang_win-64=%fortran_compiler_version%

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
