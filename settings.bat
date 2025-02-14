echo off

::API SETTINGS
SET APP_PATH=%~dp0
SET APP_PATH=%APP_PATH:~0,-1%
SET APP_GITHUB_APIURL=https://api.github.com

:: FLAG
SET APP_SETTING_LOADED=1

:: SETTINGS
SET APP_DEBUG=0

:: CUSTOM PATHS
SET APP_LIB_PATH=%APP_PATH%\lib
SET APP_LIB_GIT_PATH=%APP_LIB_PATH%\git
SET APP_LIB_GITHUB_PATH=%APP_LIB_PATH%\github
SET APP_LIB_UTILITIES_PATH=%APP_LIB_PATH%\utilities
SET APP_LIB_STYLE_PATH=%APP_LIB_PATH%\style

:: DEBUG
IF "%APP_DEBUG%"=="2" ECHO APP_SETTING Loading...

:: ADDING STYLE-COLOR
CALL %APP_LIB_STYLE_PATH%\color.bat
CALL %APP_PATH%\colorpallet.bat

