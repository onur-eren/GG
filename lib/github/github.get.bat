@ECHO off
GOTO :MAIN 
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2 
    exit /b %~1
    goto :eof

:INIT
    IF NOT "%APP_SETTING_LOADED%"=="1" SET SF_GITHUB_GET=1& CALL %~dp0..\..\settings.bat
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    goto :eof

:: ====== MAIN ======
:MAIN
    SETLOCAL
    CALL :INIT
    :: SET OR GETSET ARGUMENT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REPONAME %~1

    :: STABILIZE ARGUIMENTS
    IF "%REPONAME%"=="" ECHO argumants are empty & IF DEFINED APP_DEBUG IF "%APP_DEBUG%" GEQ "3" pause & CALL :endwitherror 5 & GOTO :end

    :: CHECK GITHUB CREDENTIALS and LOAD IF NEEDED
    CALL %APP_LIB_GITHUB_PATH%\github.memory.token.bat
    IF NOT "%ERRORLEVEL%"=="1" CALL :endwitherror 0 & goto :end

    :: PREPARE COMMAND AND ERROR MESSAGE
    SET CMD_GET=curl %APP_GITHUB_APIURL%/repos/%GITHUBUSER%/%REPONAME% --request GET  --header ""Authorization: token %GITHUBTOKEN%""
  
    :: EXECUTE
    CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "%CMD_GET%" array len

    :: GETTING full_name
    CALL %APP_LIB_UTILITIES_PATH%\get.json.bat array "full_name" JSON
    IF "%APP_DEBUG%" GEQ "2" ECHO getjson ERRORLEVEL %ERRORLEVEL%
    
    IF "%ERRORLEVEL%"=="1" IF "%JSON%"=="%GITHUBUSER%/%REPONAME%" (
        IF "%APP_DEBUG%" GEQ "2" ECHO %REPONAME% respitory found in http://github.com/%GITHUBUSER%/%REPONAME%
        CALL :endwitherror 1 & GOTO :end
    )
    :: full_name NOT EXIST
    IF "%APP_DEBUG%" GEQ "2" ECHO full_name not exist. Checking message in JSON
    
    :: GETTING MESSAGE
    CALL %APP_LIB_UTILITIES_PATH%\get.json.bat array "message" JSON
    IF "%APP_DEBUG%" GEQ "2" ECHO getjson ERRORLEVEL %ERRORLEVEL%

    :: CHEKCING MASSAGE - Not Found
    IF "%ERRORLEVEL%"=="1" IF "%JSON%"=="Not Found" (
        IF "%APP_DEBUG%" GEQ "2" ECHO %REPONAME% respitory not exist
        IF DEFINED SF_GITHUB_GET ECHO %REPONAME% respitory not exist
        CALL :endwitherror 0 & GOTO :end
    )

    :: DONT NEED THIS BUT JUST IN CASE. 
    IF "%ERRORLEVEL%"=="1" IF "%JSON%"=="Bad credentials" (
        ECHO !!!!! FATAL ERROR: Bad credentials
        CALL :endwitherror 5 & GOTO :end
    )
    
    ECHO unknown error on on github.get JSON: %JSON%
    pause & CALL :endwitherror 0

:end
    IF DEFINED SF_GITHUB_GET CALL %APP_LIB_UTILITIES_PATH%\pause.bat 10
    ENDLOCAL
