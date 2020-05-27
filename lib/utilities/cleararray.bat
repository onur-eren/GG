echo off
SETLOCAL
IF NOT "%~1"=="" SET arrayname=%~1& GOTO :MAIN
SET /p arrayname=Enter arrayname

:MAIN
:: DEGUB REPORT
IF NOT DEFINED APP_DEBUG ECHO %arrayname% is preparing to be erased
IF "%APP_DEBUG%" GEQ "3" ECHO %arrayname% is preparing to be erased

:: END IF NOT NECCESARY
IF NOT DEFINED arrayname[0] GOTO :eof

:: CLEAR
for /f "delims=[=] tokens=1,2,3" %%G in ('set %arrayname%[') do (
    IF NOT DEFINED APP_DEBUG  CALL ECHO clearing... [%%H] %%I
    IF "%APP_DEBUG%" GEQ "3" CALL ECHO clearing... [%%H] %%I
    CALL SET %%arrayname%%[%%H]=
)
ENDLOCAL