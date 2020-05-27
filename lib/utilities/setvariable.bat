echo off

IF "%APP_DEBUG%" GEQ "3" (
    ECHO ___SETVARIABLE___
    ECHO ARG1 `%1`
    ECHO ARG2 `%2`
)
:: EMPTY VARAIBLE
IF [%~2] EQU [] SET /P %1="%1 is not set.Enter %1: " & goto :eof
SET %1=%2
