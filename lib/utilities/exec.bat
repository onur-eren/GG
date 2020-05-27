echo off
GOTO :MAIN
:endwitherror
    IF "%APP_DEBUG%" GEQ "2" (
        CALL %APP_LIB_STYLE_PATH%\color.bat -1
        CALL %APP_LIB_STYLE_PATH%\style.bat header end %~n0%~x0 2
    )
    exit /b %~1

:MAIN
IF NOT "%~4"=="" (
    ECHO DOING CD
    SET PREVCD_EXEC=%CD%
    CD %~4
)

IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat

IF "%APP_DEBUG%" GEQ "2" (
    CALL %APP_LIB_STYLE_PATH%\color.bat ~ %COLORINDEX_EXEC%
    CALL %APP_LIB_STYLE_PATH%\style.bat header start %~n0%~x0 2
)

:: LENGTH=-1 for error
IF NOT "%~3"=="" set %3=-1
SET CMD=%~1
:: Remove DOuble Quotes
SET CMD=%CMD:""="%
IF "%APP_DEBUG%" GEQ "2"  ECHO CMD: %CMD% 

set /A i=0
for /f "tokens=*" %%a in ( '%CMD% 2^>^&1' ) do (
    CALL SET LINE=%%a
    REM CALL SET LINE=%%LINE:"=""%%
    IF "%APP_DEBUG%" GEQ "2" CALL echo [%%i%%] %%a
    CALL SET %2[%%i%%]=%%a
    set /A i+=1

    :: PUSH ARRAY
    REM SET line=%%a
    REM SET line=!line:"=""!
    REM :: DEBUG
    REM IF "%APP_DEBUG%" GEQ "2" echo [!i!] !line!
    REM CALL ECHO %%line%%
    REM SET %2[!i!]=%%line%%
    REM set /A i+=1
)

IF DEFINED PREVCD_EXEC ECHO going back & CD %PREVCD_EXEC%

IF %i% GEQ 1 IF NOT "%~3"=="" set %~3=%i%

IF "%APP_DEBUG%" GEQ "2" echo length: %i%
REM echo ar: %array[0]%
CALL :endwitherror 0