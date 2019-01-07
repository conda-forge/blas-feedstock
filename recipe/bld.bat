mkdir build
cd build

dir %LIBRARY_LIB%

REM Trick to avoid CMake/sh.exe error
ren "C:\Program Files\Git\usr\bin\sh.exe" _sh.exe

REM Link against the netlib libraries
cmake -G"MinGW Makefiles" .. ^
    "-DBLAS_LIBRARIES=%LIBRARY_LIB%\blas.lib;%LIBRARY_LIB%\cblas.lib" \
    "-DLAPACK_LIBRARIES=%LIBRARY_LIB%\lapack.lib;%LIBRARY_LIB%\lapacke.lib" \
    -DBUILD_TESTING=yes \
    -DCMAKE_BUILD_TYPE=Release \

mingw32-make -j%CPU_COUNT%

