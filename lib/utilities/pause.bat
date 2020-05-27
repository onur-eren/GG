echo off
IF "%~1"=="" ( SET PUASE_TIMER=5 ) ELSE ( SET PUASE_TIMER=%~1 )
ECHO.
CHOICE /T %PUASE_TIMER% /D N /M "closing in %PUASE_TIMER% seconds... Would you like to Pause"

IF "%ERRORLEVEL%"=="1" pause