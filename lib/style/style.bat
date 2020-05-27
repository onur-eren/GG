echo off
GOTO :MAIN

:HEADER
    IF "%~1"=="start" (
        REM IF "%APP_DEBUG%" GEQ "%~3" ECHO. & ECHO ___________ %~2 ___________
         ECHO. & ECHO ___________ %~2 ___________
        goto :eof
    )
    IF "%~1"=="end" (
        REM IF "%APP_DEBUG%" GEQ "%~3" ECHO /////////// END %~2 /////////// & ECHO.
        ECHO /////////// END %~2 /////////// & ECHO.
        goto :eof
    )

:MAIN
    IF "%~1"=="header" (
       CALL :HEADER %~2 %~3 %~4
    )