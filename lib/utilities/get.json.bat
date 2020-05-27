echo off

GOTO :MAIN
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" (
        CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2 
        CALL %APP_LIB_STYLE_PATH%\color.bat -1
    )
    exit /b %~1

:MAIN
    IF NOT DEFINED APP_SETTING_LOADED ( 
        SET APP_SINGLE_JSON=1
        CALL %~dp0..\..\settings.bat
    )
    SET %3=

    :: HEADERS
    IF "%APP_DEBUG%" GEQ "2" (
        CALL %APP_LIB_STYLE_PATH%\color.bat ~ %COLORINDEX_JSON%
        CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    )

    SETLOCAL EnableDelayedExpansion
    :: SET OR GETSET ARGUMENT
    REM CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat JSON_STRING "%~1"

    SET array.name=%~1
    SET key=%~2
    IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "3" (
        :: PRINT ARGUIMENTS
        ECHO ARG1-array.name: `%array.name%`
        ECHO ARG2-key: `%key%`
        ECHO return:`%3`
    )

    SET JSONINDEX=
    for /f "delims=[=] tokens=1,2,3" %%G in ('set %array.name%[') do (
        REM echo %%G...%%H...%%I
        SET line=%%I
        REM ECHO line:`!line:\""=`!`
        SET MID=%%b
        FOR /f tokens^=1-4^ delims^=^" %%a in ("!line:\""=`!") do (
            REM ECHO [%%H] "%key%"=="%%a"       `%%b`       `%%c`       `%%d`
            IF "%%a"=="%key%" (
                SET JSONINDEX=%%H
                SET MID=%%b & SET MID=!MID: =!
                REM ECHO MID=!MID!
                IF "!MID!"==":" (
                    SET MESSAGE=%%c
                    IF NOT "!MESSAGE!"=="" SET MESSAGE=!MESSAGE:`="!
                    GOTO :FOUND
                )
                ::MID WORK
                ECHO MID WORK
                SET MESSAGE=!MID:~1!
                GOTO :FOUND
            )
        )
    )
    :: NOTFOUND
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO NO MATCH on `%key%`
    CALL :endwitherror 0
    goto :eof
    
    :FOUND
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" echo [%MID%] FOUND `%key%` on index [%JSONINDEX%]: `!MESSAGE!`
    :: RETURN
    ENDLOCAL & SET %3=%MESSAGE%& IF NOT "%~4"=="" SET %4=%JSONINDEX%
    CALL :endwitherror 1

