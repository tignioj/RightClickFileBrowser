@echo off
Setlocal EnableDelayedExpansion
:: Detect Permissions
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo "Please run this script as Administrator"
    pause
    exit /B 1
) else ( goto gotAdmin )


:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    @REM detect is program running...
    tasklist /FI "IMAGENAME eq filebrowser.exe" 2>NUL | find /I /N "filebrowser.exe">NUL
    if "%ERRORLEVEL%"=="0" (
        tasklist /FI "ImageName eq filebrowser.exe" 
        echo Program is running, kill all process?
        set /p userIn="Enter(Y/N):"
        echo "Your input:!userIn!"
        if "!userIn!" EQU "Y" (
            goto killThemAll
        ) else (
            exit /B 1
        )
    ) else (
        goto startUninstall
    )
    exit /B 0

:killThemAll
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
    goto startUninstall

:startUninstall
    @REM Adding Registry
    REG DELETE HKEY_CLASSES_ROOT\Directory\shell\RightClickFileBrowser /f  >nul 2>&1
    REG DELETE HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser /f  >nul 2>&1
    REG DELETE HKEY_CLASSES_ROOT\*\shell\RightClickFileBrowser /f  >nul 2>&1

    del /f filebrowser.exe >nul 2>&1
    del /f filebrowser.db >nul 2>&1
    if '%errorlevel%' NEQ '0' (
        echo "Uninstall failed!"
    ) ELSE (
        echo "Uninstall successfully!"
    )
    pause