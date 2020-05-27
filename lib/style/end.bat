echo off
IF NOT "%~2"=="" ( 
    CALL %APP_LIB_UTILITIES_PATH%\pause.bat %~2
    exit /b 0
)
CALL %APP_LIB_STYLE_PATH%\color.bat -1
IF NOT "%~1"=="" (
    exit /b %~1
) ELSE (
    exit /b 0
)