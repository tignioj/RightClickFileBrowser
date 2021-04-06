@echo off
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
SET port=8090
SET address="0.0.0.0"
SET databasePath=%~dp0filebrowser.db
SET shareDirectory=%1

%~dp0filebrowser.exe --noauth -a %address% -p %port%  -d %databasePath%  -r %shareDirectory%
pause