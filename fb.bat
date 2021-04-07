@echo off
@REM 如果不开启这个Setlocal EnableDelayedExpansion(变量延迟),则用户的输入无法读取
Setlocal EnableDelayedExpansion
SET port=8090
SET address="0.0.0.0"
SET databasePath=%~dp0filebrowser.db
SET shareDirectory=%1

@REM 检测程序是否存在，如果不存在，则退出脚本
if not exist "%~dp0filebrowser.exe" (
        echo "filebrowser.exe NOT FOUND!"
        echo "Please check if filebrowser.exe exists in %~dp0, then rerun this script."
        pause
        exit /b 1
    ) 

@REM 先检测端口
goto detectPort
@REM 输出正在使用端口的程序，如果没有输出，则errorlevel为1，直接执行runIt，否则执行killPort
:detectPort
    netstat -o -n -a | findstr "%port%"
    if '%errorlevel%' GEQ '1'  (
        goto runIt
    ) else (
        goto killPort
    )



:killPort
    echo port is already in use, forced close it now?
    set /p userIn="Enter(Y/N):"
    echo "Your input:!userIn!"
    if "!userIn!" EQU "Y" (
        @REM netstat -o -n -a ^| findstr "%port%这个命令会打印占用端口的程序，最后一列是pid，我们需要循环拿到PID
        for /f "delims=" %%L in ('netstat -o -n -a ^| findstr "%port%"') do (
            set "line=%%L"
            for %%C in (!line!) do set last_col=%%C
            echo "kill !last_col!"
            @REM 强制关闭端口，由于开启了变量延迟，用!变量名!引用
            taskkill /f /pid !last_col! >nul 2>&1
        )
        @REM 关闭占用端口的程序后，重新检测
        goto detectPort
    ) else (
        exit /B 1
    )


:runIt
    @REM %~dp0 current directory 
    @REM %1 first param
    @REM -a listen address 
    @REM -p listen port 
    @REM -r listen path root 
    @REM --noauth use the noauth auther when
    echo ---------------------------------------
    echo Script Directory:%0
    echo Execute path:"%CD%"
    echo Sharing file:%1
    echo ----------------------------------------
    echo Starting FileBrowser...


    @REM Check Port
    @REM netstat -o -n -a | findstr %port%
    @REM setlocal enableDelayedExpansion
    @REM for /f "delims=" %%L in ('netstat -o -n -a ^| findstr "%port%"') do (
    @REM     set "line=%%L"
    @REM     for %%C in (!line!) do set last_col=%%C
    @REM     echo !last_col!
    @REM     set /p userIn=Enter (Y/N):
    @REM     taskkill /f /pid !last_col!
    @REM )

    %~dp0filebrowser.exe --noauth -a %address% -p %port%  -d %databasePath%  -r %shareDirectory%