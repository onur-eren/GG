@ECHO off
IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat
SET SOURCE=%APP_PATH%\gitignores

CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat DESTINATION "%~1"

IF NOT EXIST %DESTINATION% ECHO `%DESTINATION%` destination not exist & exit /b 1

CALL %APP_LIB_UTILITIES_PATH%\get.filefromfolder.bat %SOURCE% file 
ECHO file:%file%
CALL %APP_LIB_UTILITIES_PATH%\copy.bat "%SOURCE%\%file%" "%DESTINATION%\%file%"

exit /b 0