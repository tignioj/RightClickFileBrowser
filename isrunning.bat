@echo off
Setlocal EnableDelayedExpansion

:detectProcess
    tasklist /FI "IMAGENAME eq filebrowser.exe" 2>NUL | find /I /N "filebrowser.exe">NUL
    if "%ERRORLEVEL%"=="0" (
        tasklist /FI "ImageName eq filebrowser.exe" 
        echo Program is running
        echo kill all process?
        set /p userIn="Enter(Y/N):"
        echo "Your input:!userIn!"
        if "!userIn!" EQU "Y" (
            goto killThemAll
        ) else (
            exit /B 1
        )
    ) else (
        echo not running
    )
    exit /B 0

:killThemAll 
    echo killing...
    for /F "delims=" %%R in ('
        tasklist /FI "ImageName eq filebrowser.exe" /FO CSV /NH
    ') do (
        set "FLAG1=" & set "FLAG2="
        for %%C in (%%R) do (
            if defined FLAG1 (
                if not defined FLAG2 (
                    echo %%~C
                    taskkill /f /pid %%~C
                )
                set "FLAG2=#"
            )
            set "FLAG1=#"
        )
    )
    goto afterKill

:afterKill
    echo afterKill