ECHO off

SET APP_DEBUG=3
CALL ../settings.bat

CALL %APP_LIB_STYLE_PATH%\color.bat ~ 1 & ECHO 1
CALL %APP_LIB_STYLE_PATH%\color.bat ~ 2 & ECHO 1
CALL %APP_LIB_STYLE_PATH%\color.bat ~ 3 & ECHO 1
CALL %APP_LIB_STYLE_PATH%\color.bat -1 & ECHO 2
CALL %APP_LIB_STYLE_PATH%\color.bat -1 & ECHO 2
CALL %APP_LIB_STYLE_PATH%\color.bat -1 & ECHO 2
CALL %APP_LIB_STYLE_PATH%\color.bat -1 & ECHO 2



pause