@echo off
SETLOCAL
REM IF "%APP_DEBUG%" GEQ "2" ECHO Arg2:'%2' Arg1:'%~1'
IF "%~1"=="" ( SET /P STR="strlen.bat: STR is not set. Enter STR: " ) ELSE ( SET STR=%~1)
IF "%APP_DEBUG%" GEQ "3" ECHO RAW:`%STR%`
:: FIX SPECIAL CHAR ! for EnableDelayedExpansion
SET STR=%STR:!=^!%

SETLOCAL EnableDelayedExpansion

SET /A LEN=0
::LOOP
:strLen_Loop
    if "!STR:~%LEN%,1!"=="" GOTO :endloop
    IF "%APP_DEBUG%" GEQ "4" ECHO [!LEN!] !STR:~%LEN%,1!
    set /A LEN+=1
    :: DEBUG for ENDLESS LOOP MAX 6666
    IF "%LEN%" GTR 6666 SET LEN=-1 & goto :endloop
    goto :strLen_Loop

:endloop

:: DEBUG
IF "%APP_DEBUG%" GEQ "3" ECHO len:%LEN%

:: END - RETURN
ENDLOCAL & ENDLOCAL & IF NOT "%~2"=="" SET %2=%LEN%