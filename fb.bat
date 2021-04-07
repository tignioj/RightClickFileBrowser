@echo off
Setlocal EnableDelayedExpansion
@REM %~dp0 current directory 
@REM %1 first param
@REM -a listen address 
@REM -p listen port 
@REM -r listen path root 
@REM --noauth use the noauth auther
SET port=8090
SET address="0.0.0.0"
SET databasePath=%~dp0filebrowser.db
SET shareDirectory=%1


@REM detect filebrowser.exe is existed.
if not exist "%~dp0filebrowser.exe" (
        echo "filebrowser.exe NOT FOUND!"
        echo "Please check if filebrowser.exe exists in %~dp0, then rerun this script."
        pause
        exit /b 1
    ) 


goto detectPort
@REM show which program using port
:detectPort
    netstat -o -n -a | findstr "%port%" | find "LISTENING"
    if '%errorlevel%' GEQ '1'  (
        goto runIt
    ) else (
        goto killPort
    )


:killPort
    echo port %port% is already in use, forced close it now?
    set /p userIn="Enter(Y/N):"
    echo "Your input:!userIn!"
    if "!userIn!" EQU "Y" (
        for /f "delims=" %%L in ('netstat -o -n -a ^| findstr "%port%"') do (
            set "line=%%L"
            for %%C in (!line!) do set last_col=%%C
            echo "kill !last_col!"
            @REM force close process
            taskkill /f /pid !last_col! >nul 2>&1
        )
        goto detectPort
    ) else (
        exit /B 1
    )


:runIt
    echo ---------------------------------------
    echo Script Directory:%0
    echo Execute path:"%CD%"
    echo Sharing file:%1
    echo ----------------------------------------
    echo Starting FileBrowser...

    echo %shareDirectory%
    %~dp0filebrowser.exe --noauth -a %address% -p %port%  -d %databasePath%  -r %shareDirectory%
