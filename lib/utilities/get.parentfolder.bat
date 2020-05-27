@echo off
IF "%~1"=="" (
    ECHO FOLDERPATH is not set.
    SET /P %1="Enter FOLDERPATH: "
) 

for %%i in ("%~1\..") do SET %~2=%%~fi