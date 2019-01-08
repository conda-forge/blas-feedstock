mkdir build
cd build

dir %LIBRARY_LIB%

REM Trick to avoid CMake/sh.exe error
ren "C:\Program Files\Git\usr\bin\sh.exe" _sh.exe

set CPATH="%CPATH%;%LIBRARY_INC%"
set LIBRARY_PATH="%LIBRARY_PATH%;%LIBRARY_LIB%"

REM Link against the netlib libraries
cmake -G"MinGW Makefiles" .. ^
    "-DBLAS_LIBRARIES=blas.lib;cblas.lib" ^
    "-DLAPACK_LIBRARIES=lapack.lib;lapacke.lib" ^
    -DBUILD_TESTING=yes ^
    -DCMAKE_BUILD_TYPE=Release

mingw32-make VERBOSE=1

