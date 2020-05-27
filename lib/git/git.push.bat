@ECHO off

SETLOCAL
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2

:: SET ARGUMENT
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITPATH "%~1"

:: HANDLE PATH
SET PREVCD_GIT_PUSH=%CD%
CD %GITPATH%

:: DEBUG
IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git push -u origin master

:: EXEC
CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git push -u origin master" array len
CD %PREVCD_GIT_PUSH%

:: SUCCESS
CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "Branch 'master' set up to track remote branch 'master' from 'origin'."
IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL: %ERRORLEVEL%
IF "%ERRORLEVEL%"=="1" ENDLOCAL & EXIT /b 1

:: FETCH NEEDED
CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[1]%" "! [rejected]"
IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL: %ERRORLEVEL%
IF "%ERRORLEVEL%"=="1" ENDLOCAL & EXIT /b 2

:: FATAL
IF "%APP_DEBUG%" GEQ "2" (
    ECHO UNKNOWN RESPONSE
    ECHO [0] `%array[1]%` 
    ECHO [1] `%array[1]%`
)
ENDLOCAL & EXIT /b 5