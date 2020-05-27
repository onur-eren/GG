@ECHO off
GOTO :MAIN

:PUSH
    ECHO Pushing git to remote url...
    SET array=& SET len=
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git push -u origin master" array len

    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "Branch 'master' set up to track remote branch 'master' from 'origin'."
    IF "%ERRORLEVEL%"=="1" (
        ECHO SUCCESS
        exit /b 0
        goto :end
    )
    ECHO ERROR
    exit /b 1
    goto :end

:MAIN
    CALL settings.bat
    CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 1
    
    :: CHECK GITHUB CREDENTIALS and LOAD IF NEEDED
    CALL %APP_LIB_GITHUB_PATH%\github.memory.token.bat
    IF NOT "%ERRORLEVEL%"=="1" GOTO :end
    
    REM ECHO ARGS %*
    :: SET OR GETSET ARGUMENT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat GITPATH %~1
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REPONAME %~2

:GIT_INIT 
    :: GITPATH is the Path where your local project exist
    CALL %APP_LIB_GIT_PATH%\git.init.bat "%GITPATH%"

:GIT_GET_REMOTE 
    CALL %APP_LIB_GIT_PATH%\git.get.remote.bat "%GITPATH%" "origin" FINDS
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO git.get.remote.bat ERRORLEVEL=%ERRORLEVEL%
    
    ::ERRORLEVEL IF 1(fetch only) OR 0(none)
    IF "%ERRORLEVEL%" LSS "2" GOTO :REMOTEGITNOTEXIST
    
    :: CHECK IF ORIGION IS SAME
    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%FINDS[1]%" "https://github.com/%GITHUBUSER%/%2"
    
    :: (1) SAME
    IF "%ERRORLEVEL%"=="1" GOTO :GITHUB
    :: ELSE
    :: CONTIUNE

:REMOTEGITEXIST
    :: CHOICE
    ECHO. & ECHO would you like to delete origin '%FINDS[1]%'
    CHOICE /T 30 /C NY /D N /M "auto N will be selected after 20 seconds..."

    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL=%ERRORLEVEL%
    
    :: CHOICE (2) YES DELETE
    IF NOT "%ERRORLEVEL%"=="2" GOTO :GITHUB
    CALL %APP_LIB_GIT_PATH%\git.remove.remote.bat %GITPATH% origin

    :: ELSE
    :: CONTIUNE

:REMOTEGITNOTEXIST
    :: ADD REMOTE
    CALL %APP_LIB_GIT_PATH%\git.add.remote.bat %GITPATH% "https://github.com/%GITHUBUSER%/%2/"

    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO addremote ERRORLEVEL=%ERRORLEVEL%

    :: ERRORLEVEL NOT 1
    IF NOT "%ERRORLEVEL%"=="1" goto :end

    ::ERRORLEVEL 1 CONTINUE

:GITHUB
    :: GITHUB GET
    CALL %APP_LIB_GITHUB_PATH%\github.get.bat "%REPONAME%"
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL=%ERRORLEVEL%

    :: ERRORLEVEL 0 non exist
    IF "%ERRORLEVEL%"=="5" goto :end
    IF "%ERRORLEVEL%"=="0" goto :GITHUB_CREATE
    
    :: ELSE, respitory exist
    :: CONTIUNE

:GITHUB_EXIST
    CALL %APP_LIB_GITHUB_PATH%\github.isneeded.push.bat %GITPATH%
    IF "%APP_DEBUG%" GEQ "2" ECHO ERRORLEVEL=%ERRORLEVEL%
    :: NO PUSH NEEDE
    IF "%ERRORLEVEL%"=="0" ECHO NO push needed. & GOTO :end
    :: PUSH
    GOTO :GITHUB_PUSH

:GITHUB_CREATE
    :: GITHUB CREATE
    CALL %APP_LIB_GITHUB_PATH%\github.create.bat "%REPONAME%"
    :: DEBUG
    IF "%APP_DEBUG%" GEQ "2" ECHO CREATE ERRORLEVEL=%ERRORLEVEL%
    :: CONTIUNE

:GITHUB_PUSH
    :: GIT PUSH
    CALL %APP_LIB_GIT_PATH%\git.push.bat %GITPATH%

    :: ERRORLEVEL 1 - SUCCESS
    IF "%ERRORLEVEL%"=="1" (
        ECHO. & ECHO PUSH completed 
        goto :end
    )
    IF "%ERRORLEVEL%"=="2" (
        ECHO. & ECHO !!! FETCH NEEDED & ECHO. 
        goto :end
    )
    :: ELSE
    ECHO UNKNOWN PUSH. ERRORLEVEL: %ERRORLEVEL%
    :: CONTINUE

:end
    CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 1 
    CALL %APP_LIB_UTILITIES_PATH%\pause.bat 10
