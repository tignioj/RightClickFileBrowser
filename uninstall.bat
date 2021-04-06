@echo off

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
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo "Please run this script as Administrator"
    pause
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

@REM Adding Registry
REG DELETE HKEY_CLASSES_ROOT\Directory\shell\RightClickFileBrowser /f  >nul 2>&1
REG DELETE HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser /f  >nul 2>&1
REG DELETE HKEY_CLASSES_ROOT\*\shell\RightClickFileBrowser /f  >nul 2>&1
if '%errorlevel%' NEQ '0' (
    echo "Uninstall failed!"
) ELSE (
    echo "Uninstall successfully!"
)
pause