echo off
GOTO :MAIN 
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1 
    EXIT /b %~1
    goto :eof

:INIT
    :: CHECK APP_SETTINGS AND LOAD IF NEEDED
    IF NOT "%APP_SETTING_LOADED%"=="1" SET SF_GITHUB_CREATE=1& CALL %~dp0..\..\settings.bat
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    goto :eof 
:: ====== MAIN ======
:MAIN
    SETLOCAL
    CALL :INIT
    :: SET OR GETSET ARGUMENT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REPONAME %~1

    :: PRINT ARGUIMENTS
    IF "%APP_DEBUG%" GEQ "2" ECHO ARG1-REPONAME: %1

    :: STABILIZE ARGUIMENTS
    IF "%REPONAME%"=="" ECHO argumants are empty & IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "3" pause & CALL :endwitherror 5

    :: CHECK GITHUB CREDENTIALS and LOAD IF NEEDED
    CALL %APP_LIB_GITHUB_PATH%\github.memory.token.bat
    IF NOT "%ERRORLEVEL%"=="1" CALL :endwitherror 0 & goto :end

    :: PREPARE COMMAND AND ERROR MESSAGE
    SET CMD_CREATE=curl %APP_GITHUB_APIURL%/user/repos --request POST  --header ""Authorization: token %GITHUBTOKEN%""  --data ""{\"name\":\"%REPONAME%\",\"private\":\"true\"}""
    
    :: EXECUTE
    CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "%CMD_CREATE%" array 
    CALL %APP_LIB_UTILITIES_PATH%\strlen.bat "%array[10]:"=""%" lenx
    :: GET JSON
    CALL %APP_LIB_UTILITIES_PATH%\get.json.bat array "message" JSON
    REM ECHO ERRORLEVEL: %ERRORLEVEL% "%JSON%"=="name already exists on this account"
    IF "%ERRORLEVEL%" EQU "1" IF "%JSON%"=="name already exists on this account" (
            ECHO %REPONAME% respitory exist
            pause
            CALL :endwitherror 0 & goto :end
        )
    )
    CALL %APP_LIB_UTILITIES_PATH%\get.json.bat array "full_name" JSON
    REM ECHO ERRORLEVEL: %ERRORLEVEL% "%JSON%"=="%GITHUBUSER%/%REPONAME%"
    IF "%ERRORLEVEL%" EQU "1" IF "%JSON%"=="%GITHUBUSER%/%REPONAME%" (
        ECHO %REPONAME% respitory created
        CALL :endwitherror 1 
        goto :end
    )
    
    ECHO unknown error on github create: %JSON[0]%=%JSON[1]%
    pause
    CALL :endwitherror 0

    :end
        IF DEFINED SF_GITHUB_CREATE CALL %APP_LIB_UTILITIES_PATH%\pause.bat 10
        ENDLOCAL