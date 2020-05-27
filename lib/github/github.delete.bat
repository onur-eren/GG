echo off
GOTO :MAIN 
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1 
    EXIT /b %~1

:INIT
    :: CHECK APP_SETTINGS AND LOAD IF NEEDED
    IF NOT "%APP_SETTING_LOADED%"=="1" SET SF_GITHUB_DELETE=1& CALL %~dp0..\..\settings.bat
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    goto :eof

:: ====== MAIN ======
:MAIN
    SETLOCAL
    CALL :INIT
    :: SET OR GETSET ARGUMENT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REPONAME %~1

    :: PRINT ARGUIMENTS
    IF NOT "%APP_DEBUG%"=="0" ECHO ARG1-REPONAME: %1

    :: STABILIZE ARGUIMENTS
    IF "%REPONAME%"=="" ECHO argumants are empty & IF "%APP_DEBUG%" GEQ "3" pause & CALL :endwitherror 5 & goto :eof

    :: CHECK GITHUB CREDENTIALS and LOAD IF NEEDED
    CALL %APP_LIB_GITHUB_PATH%\github.memory.token.bat
    IF NOT "%ERRORLEVEL%"=="1" CALL :endwitherror 0 & goto :end

    :: PREPARE COMMAND
    SET CMD_DELETE=curl %APP_GITHUB_APIURL%/repos/%GITHUBUSER%/%REPONAME% -L --request DELETE --header ""Authorization: token %GITHUBTOKEN%""
    
    :: EXECUTE
    CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "%CMD_DELETE%" array len

    :: GET JSON
    CALL %APP_LIB_UTILITIES_PATH%\get.json.bat array "message" JSON
    IF "%APP_DEBUG%" GEQ "2" ECHO github.delete get.json ERRORLEVEL: %ERRORLEVEL%
    
    :: NOT FOUND called for Bad Credentials as well as non repository 
    IF "%ERRORLEVEL%" EQU "1" IF "%JSON%"=="Not Found" (
        ECHO %REPONAME% respitory doest not exist
        CALL :endwitherror 0 & GOTO :end
    )

    IF "%JSON%"=="" (
        ECHO %REPONAME% respitory deleted
        CALL :endwitherror 1 & GOTO :end
    )
    
    ECHO ***** unknown error on github.delete `%JSON%`. Assuming %REPONAME% respitory deleted
    CALL :endwitherror 1

:end
    IF DEFINED SF_GITHUB_DELETE CALL %APP_LIB_UTILITIES_PATH%\pause.bat 10
    ENDLOCAL
