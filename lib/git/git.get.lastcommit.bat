@ECHO off
GOTO :MAIN 
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2
    exit /b %~1
    
:INIT

    IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
    IF "%APP_DEBUG%" GEQ "2" CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2
    goto :eof

:: ====== MAIN ======
:: (1) TARGETPATH=github full path
:: (2) REMOTENAME=aliasname of remote url
:: (3) =return array [fetch,push]
:MAIN
    SETLOCAL
    CALL :INIT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat TARGETPATH "%~1"

    :: EXEC
    SET PREVCD_GIT_LASTCOMMIT=%CD%
    CD %TARGETPATH%
    CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git log --pretty^^=format:""%%%%s""" array len
    CD %PREVCD_GIT_LASTCOMMIT%

    :: GET COMMIT
    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "GG"
    IF "%APP_DEBUG%" GEQ "2" ECHO compare GG ERRORLEVEL %ERRORLEVEL%
    IF "%ERRORLEVEL%"=="1" ENDLOCAL & SET %2=%array[0]:~2%& CALL :endwitherror 1 & goto:eof

    :: CHECK NOT FOUNF is RELATED TO INIT EXIST
    CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "%array[0]%" "fatal: not a git repository"
    IF "%APP_DEBUG%" GEQ "2" ECHO compare fatal: not a git repository ERRORLEVEL %ERRORLEVEL%
    IF "%ERRORLEVEL%"=="1" ENDLOCAL & CALL :endwitherror 5 & goto:eof
    
    :: UNKNOWN ERROR
    ENDLOCAL & ECHO COMMIT NOT GG. `%array[0]%` & CALL :endwitherror 0 & pause
    
    
  