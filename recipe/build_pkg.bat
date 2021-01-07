REM batch is too stupid for or-conditions (much less nesting), so do it manually
set "REPACK=F"
if "%blas_impl%"=="blis" (
    REM blis does not package liblapack(e); repack netlib-variant
    if "%PKG_NAME%"=="liblapack" (
        set "REPACK=T"
    )
    if "%PKG_NAME%"=="liblapacke" (
        set "REPACK=T"
    )
)
set "NEW_ENV=%cd%\\_env"
if "%REPACK%"=="T" (
    set "CONDA_SUBDIR=%target_platform%"
    conda.exe create -p %NEW_ENV% -c conda-forge --yes --quiet ^
        liblapack=%PKG_VERSION%=*netlib ^
        liblapacke=%PKG_VERSION%=*netlib
    set "CONDA_SUBDIR="
    copy "%NEW_ENV%\\Library\\bin\\%PKG_NAME%.dll" "%LIBRARY_BIN%\\%PKG_NAME%.dll"
    REM cut short the rest of the script
    exit 0
)

copy "%LIBRARY_BIN%\\%blas_impl_lib%" "%LIBRARY_BIN%\\%PKG_NAME%.dll"
