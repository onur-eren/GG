@ECHO off

SETLOCAL
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2

:: SET OR GETSET ARGUMENT
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITPATH %~1

SET PREVCD_GIT_COMMIT=%CD%   
CD %GITPATH%

:: GIT ADD   
IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git add . 
git add .>NUL

:: GET LAST COMMIT
CALL %APP_LIB_GIT_PATH%\git.get.lastcommit.bat %GITPATH% lastcommit
IF "%ERRORLEVEL%"=="0" ECHO CUSTOM COMMIT. CAN NOT AUTO COMMIT. Commit index starting from 0 & SET /A lastcommit=-1
SET /A lastcommit+=1

:: GIT COMMIT
IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "2" ECHO.& ECHO $^>git commit -m "GG%lastcommit%"
CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git commit -m ""GG%lastcommit%""" array len
ECHO git commited as `GG%lastcommit%`

:: RETURNING TO PREVIOUS PATH
CD %PREVCD_GIT_COMMIT%

:: END MEMORY ON PREVFOLDER
IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2

:end
ENDLOCAL