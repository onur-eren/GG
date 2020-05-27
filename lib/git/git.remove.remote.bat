echo off

IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat TARGETPATH "%~1"
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REMOTENAME "%~2"
ECHO removing origin from %TARGETPATH%...
SETLOCAL
    SET PREVCD_GIT_REMOVE_REMOTE=%CD%
    CD %TARGETPATH%
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git remote rm %REMOTENAME%" array len
    CD %PREVCD_GIT_REMOVE_REMOTE%
    
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1 
ENDLOCAL