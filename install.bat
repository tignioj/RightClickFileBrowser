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
    echo "Please run this script as Administrator"
    pause
    exit /B 1
) else ( goto gotAdmin )


:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
    if not exist "%~dp0filebrowser.7z" (
            echo "filebrowser.7z NOT FOUND!"
            echo "Please check if filebrowser.7z exists in '%~dp0', then rerun this script."
            pause
            exit /b 1
        ) 

    @REM Extract filebrowser
    echo "Extracting filebrowser..."
    if not exist "%~dp0filebrowser.exe" (
        7z1900-extra\7za.exe e filebrowser.7z >nul 2>&1
        if '%errorlevel%' NEQ '0' (
            echo "Extract filebrowser failed!"
            pause
            exit /b 1
        ) ELSE (
            echo "Extract filebrowser successfully!"
        )
    ) else (
        echo "filebrowser.exe already exists"
    )


    @REM For Directory
    REG ADD HKEY_CLASSES_ROOT\Directory\shell\RightClickFileBrowser  /t REG_SZ /f /d "Share by FileBrowser"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\Directory\shell\RightClickFileBrowser /v icon  /t REG_SZ /f /d "%~dp0filebrowser.ico"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\Directory\shell\RightClickFileBrowser\command  /t REG_SZ /f /d "\"%~dp0fb.bat\" \"%%V\""  >nul 2>&1

    @REM For Directory Background
    REG ADD HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser  /t REG_SZ /f /d "Share by FileBrowser"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser /v icon  /t REG_SZ /f /d "%~dp0filebrowser.ico"  >nul 2>&1
    @REM REG ADD HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser\command  /t REG_SZ /f /d "\"%~dp0fb.bat\" %%V"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\Directory\Background\shell\RightClickFileBrowser\command  /t REG_SZ /f /d "\"%~dp0fb.bat\" \"%%V \""  >nul 2>&1

    @REM For File
    REG ADD HKEY_CLASSES_ROOT\*\shell\RightClickFileBrowser  /t REG_SZ /f /d "Share by FileBrowser"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\*\shell\RightClickFileBrowser /v icon  /t REG_SZ /f /d "%~dp0filebrowser.ico"  >nul 2>&1
    REG ADD HKEY_CLASSES_ROOT\*\shell\RightClickFileBrowser\command  /t REG_SZ /f /d "\"%~dp0fb.bat\" \"%%V\""  >nul 2>&1
    if '%errorlevel%' NEQ '0' (
        echo "Install failed!"
    ) ELSE (
        echo "Install successfully!"
    )
    pause