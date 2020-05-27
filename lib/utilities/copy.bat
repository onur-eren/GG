echo off
SETLOCAL
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat SOURCE "%~1"
CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat DESTINATION "%~2"

if exist "%DESTINATION%" (
    goto :exist
) ELSE (
    REM ECHO Copying...
    Echo N|COPY "%SOURCE%" "%DESTINATION%">nul
    goto :end
)
:exist
    REM ECHO Exist...
    CHOICE /T 20 /C NY /D N /M "would you like tyo override it. N will be selected after 20 seconds..."
    REM ECHO ERRORLEVEL:%ERRORLEVEL%
    :: CHOICE (2) YES DELETE
    IF "%ERRORLEVEL%"=="2" (
        goto :overwite
    )
    goto :end

:overwite
    REM ECHO Overriding...
    COPY /Y "%SOURCE%" "%DESTINATION%">nul
    IF NOT "%ERRORLEVEL%"=="0" (
        ECHO Unknown error on copy.bat: %ERRORLEVEL%
    )
    goto :end

:end
    ENDLOCAL