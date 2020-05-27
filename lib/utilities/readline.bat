echo off

IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" (
    CALL %APP_LIB_STYLE_PATH%\color.bat ~ %COLORINDEX_READLINE%
    CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
)

IF NOT "%APP_SETTING_LOADED%"=="1" ( ECHO APP_SETTING is empty & pause & goto :end )

IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" (
    ECHO ARG1-file: %1
    ECHO ARG2-skip: %2
    ECHO ARG3-referance: %3
)

:: EXEC
IF NOT "%~2"=="0" SET SKIP=skip=%~2
for /F "%SKIP% delims=" %%G in (%~1) do ( 
    set %3=%%G
    IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" ( ECHO Found: `%%G` ) 
    goto :end
)

:end
    IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2"  (
        CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1
        CALL %APP_LIB_STYLE_PATH%\color.bat -1 
    )
