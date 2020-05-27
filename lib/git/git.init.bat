@ECHO off
GOTO :MAIN

:: GIT ADD
:ADD
    IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git add . 
    git add .>NUL
    goto :eof

:MAIN
SETLOCAL
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2

:: SET OR GETSET ARGUMENT
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITPATH "%~1"

SET PREVCD_GIT_INIT=%CD%
CD %GITPATH%

IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git init

CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git init" array len

CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "Reinitialized"
IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL %ERRORLEVEL%
:: DEBUG
IF "%ERRORLEVEL%"=="0" (
    :: FIRST INIT
    ECHO git initiated 
    CALL :ADD
    IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git commit -m "GG0"
    git commit -m "GG0">NUL
    goto :end
)
:: ELSE - not first INIT
:: CHECK IF COMMIT NEEDED
IF "%APP_DEBUG%" GEQ "2" ECHO Reinitialized.
CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git diff --exit-code" array len
REM ECHO len:%len%

:: NO COMMIT NEEDED
IF "%len%"=="-1" ECHO no commit needed. & GOTO :end

:: ELSE 
CALL :ADD
IF "%APP_DEBUG%" GEQ "2" ECHO Reinitialized. Auto commiting
CALL %APP_LIB_GIT_PATH%\git.commit.bat %GITPATH%

:end
    :: RETURNING TO PREVIOUS PATH
    CD %PREVCD_GIT_INIT%
    :: END MEMORY ON CD_GIT_INIT
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2
    ENDLOCAL