@ECHO off
GOTO :MAIN
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2
    exit /b %~1

:MAIN
SETLOCAL
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2

:: SET OR GETSET ARGUMENT
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITPATH %~1

SET PREVCD_GH_N_PUSH=%CD%
CD %GITPATH%
CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git diff master origin/master" array len
CD %PREVCD_GH_N_PUSH%
REM ECHO ll:%len%
IF "%len%"=="-1" CALL :endwitherror 0& goto :end

CALL :endwitherror 1
:end
    ENDLOCAL