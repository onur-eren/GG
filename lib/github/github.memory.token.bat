echo off
GOTO :MAIN

:: CHECK APP_SETTINGS AND LOAD IF NEEDED
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2 
    exit /b %~1
    goto :eof

:INIT
    IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2 
    goto :eof


:MAIN
    CALL :INIT
    :: CHECK GIT ARGUIMENTS
    IF "%GITHUBUSER%"=="" IF "%GITHUBTOKEN%"=="" GOTO :EXEC
    :: NOT NEEDED
    CALL :endwitherror 1
    GOTO :eof
    
:EXEC
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO GITHUB USER or TOKEN is empty. Loading...

    :: READ FROM ENV
    CALL %APP_LIB_UTILITIES_PATH%\readline.bat "%APP_PATH%\env\github.txt" 0 GITHUBUSER
    CALL %APP_LIB_UTILITIES_PATH%\readline.bat "%APP_PATH%\env\github.txt" 1 GITHUBTOKEN

    :: CHECK IF READLINES ARE STILL EMPTY TO PREVENT LOOP
    IF "%GITHUBUSER%"=="" IF "%GITHUBTOKEN%"=="" ECHO github env file error. Might be empty& CALL :endwitherror 0 & goto :eof

    :: TEST GITHUB GET random resository `xxx`
    CALL %APP_LIB_GITHUB_PATH%\github.get.bat xxx

    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL=%ERRORLEVEL%

    :: ONLY ERRORLEVEL=1 PASS others Failed
    IF "%ERRORLEVEL%"=="5" (
        ECHO ECHO %GITHUBUSER% has Bad credentials on repository: `%REPONAME%`. Check GITHUB's username and token
        CALL :endwitherror 0
        goto :eof
    )
    :: ELSE - SUCCESS
    IF "%APP_DEBUG%" GEQ "2" ECHO SETUP as GITHUBUSER: `%GITHUBUSER%`GITHUBTOKEN: `%GITHUBTOKEN%`
    CALL :endwitherror 1