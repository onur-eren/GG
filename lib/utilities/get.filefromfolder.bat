echo off
GOTO :MAIN
:: COMMEND
:getfile
    SETLOCAL EnableDelayedExpansion
    SET index=1
    SET find=1
    FOR /R %FOLDERPATH%\ %%G IN (*.gitignore) DO  (
         IF "!index!"=="%~1" (
            SET find=%%~nxG
            goto :selectFile_next
         )
        SET /A index+=1
    )
    :selectFile_next
    ENDLOCAL & SET %2=%find%
    goto :eof
                

:listFiles
    SETLOCAL EnableDelayedExpansion
    SET index=1
    FOR /R %FOLDERPATH%\ %%G IN (*.gitignore) DO  (
        echo [!index!] %%~nxG
        SET /A index+=1
    )
    SET /A index-=1
    ENDLOCAL & SET %~1=%index%
    goto :eof

:selectIndex
    :_selection
        SET /p selected="Please select index [1-%1]"
        echo %selected%|findstr "^[-][1-9][0-9]*$ ^[1-9][0-9]*$ ^0$">nul && GOTO :_selection_nex || echo not numeric & GOTO :_selection
    :_selection_nex
        IF %selected% LEQ %len% IF %selected% GTR 0 (
            SET %~2=%selected%
            goto :eof
        )
        GOTO :_selection 
        goto :eof

:getfile
        goto :eof

:copyfile
        goto :eof

:MAIN

    IF NOT "%APP_SETTING_LOADED%"=="1" CALL %~dp0..\..\settings.bat

    CALL %APP_LIB_UTILITIES_PATH%\setvariable.bat FOLDERPATH "%~1"

    CALL :listFiles len
    :: PROMPT SELECT INDEX
    CALL :selectIndex %len% selected
    ECHO ERRORLEVEL:%ERRORLEVEL%
    :: SUCCESS
    CALL :getfile %selected% filename
    ECHO filename: %filename%
    IF NOT "%2"=="" SET %2=%filename%