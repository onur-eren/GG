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
    SETLOCAL EnableDelayedExpansion
    CALL :INIT
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat TARGETPATH %~1
    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat REMOTENAME "%~2"
    IF "%APP_DEBUG%" GEQ "2" ECHO TARGETPATH=`%TARGETPATH%`     REMOTENAME=`%REMOTENAME%`
    :: EXEC
    SET PREVCD_GET_REMOTE=%CD%
    CD %TARGETPATH%
    CALL %APP_LIB_UTILITIES_PATH%\cleararray.bat array
    CALL %APP_LIB_UTILITIES_PATH%\exec.bat "git remote -v" array len
    CD %PREVCD_GET_REMOTE%

    SET /A len-=1
    CALL %APP_LIB_UTILITIES_PATH%\strlen.bat %REMOTENAME% NAMELEN
    
    :: GET FETCH AND PUSH
    SET ISFOUND=0
    SET FINDS=
    FOR /l %%i IN (0,1,%len%) DO (
        REM CALL ECHO compare `"!array[%%i]:~0,%NAMELEN%!"` `%REMOTENAME%`
        CALL %APP_LIB_UTILITIES_PATH%\str.compare.bat "!array[%%i]:~0,%NAMELEN%!" %REMOTENAME%
        IF "%APP_DEBUG%" GEQ "2" ECHO %%i str.compare.bat ERRORLEVEL!ERRORLEVEL!
        :: SEARCH FOUND
        IF "!ERRORLEVEL!"=="1" (
            ::FLAGS none:0 fetch:1 push:2 both:3
            IF "!array[%%i]:~-6,5!"=="fetch" SET /A ISFOUND+=1& SET FINDS[0]=!array[%%i]:~7,-8!
            IF "!array[%%i]:~-5,4!"=="push" SET /A ISFOUND+=2& SET FINDS[1]=!array[%%i]:~7,-7!
        )
    )
    
    :: RETURN
    IF "%ISFOUND%" GEQ "1" (
        IF "%APP_DEBUG%" GEQ "2" ECHO FOUND fetch: %FINDS[0]% & ECHO FOUND push: %FINDS[1]%
        ENDLOCAL & SET %3[0]=%FINDS[0]%& SET %3[1]=%FINDS[1]%& CALL :endwitherror %ISFOUND%& goto :eof
    )
    
    IF "%APP_DEBUG%" GEQ "2" ECHO No remote found
    ENDLOCAL & CALL :endwitherror %ISFOUND%

    
  