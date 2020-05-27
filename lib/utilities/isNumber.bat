@echo off
GOTO :MAIN

:endwitherror
    :: FOR SINGLEFILE CALL
    IF NOT DEFINED APP_DEBUG ECHO ERRORLEVEL%ERRORLEVEL%. isNumber.bat Error Result for %number%: %~1 & pause
    
    :: FOR APP CALL
    IF "%APP_DEBUG%" GEQ "3" ECHO ERRORLEVEL%ERRORLEVEL%. isNumber.bat Error Result for %number%: %~1
    exit /b %~1
    goto :eof

:MAIN
    SET number=%~1
    IF "%number%"=="" SET /p number=Please enter number

    echo %number%|findstr "^[-][1-9][0-9]*$ ^[1-9][0-9]*$ ^0$">nul

    If %ERRORLEVEL% EQU 0 CALL :endwitherror 1 & GOTO :eof 
    CALL :endwitherror 0
