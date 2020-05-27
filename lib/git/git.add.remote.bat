@ECHO off
GOTO :MAIN
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1 
    EXIT /b %~1
:INIT
    IF NOT "%APP_SETTING_LOADED%"=="1" ( 
        REM SETLOCAL EnableDelayedExpansion 
        CALL %~dp0..\..\settings.bat
    )
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    goto :eof

:MAIN
    CALL :INIT
    :: SET OR GETSET ARGUMENT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITFOLDER "%~1"
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REMOTEURL "%~2"
    SETLOCAL
    SET PREVCD_GIT_ADD_REMOTE=%CD%
    CD %GITFOLDER%

    SET array[0]=
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git remote add origin %REMOTEURL%" array len
    CD %PREVCD_GIT_ADD_REMOTE%

    :: SUCCESS
    IF "%array[0]%"=="" (
        IF "%APP_DEBUG%" GEQ "2" ECHO MATCHED
        goto :SUCCESS
    )
    :: ERRORS
    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "fatal: remote origin already exists."
    IF "%ERRORLEVEL%"=="1" (
        ECHO FATAL. After control still Remote origion exist reached.
        GOTO :FAIL
    )

    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "fatal: No such remote:"
    IF "%ERRORLEVEL%"=="1" (
        ECHO fatal. %REMOTEURL% doesnt exist
        GOTO :FAIL
    )
    ECHO UNKNOWN ERROR 
    CALL :endwitherror 0
    goto :end

    :SUCCESS
        IF "%APP_DEBUG%" GEQ "2" ECHO SUCCESS
        CALL :endwitherror 1
        goto :end

    :FAIL
        IF "%APP_DEBUG%" GEQ "2" ECHO FAIL
    
    CALL :endwitherror 0

    :end
        ENDLOCAL
