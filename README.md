# 一款用go语言编写的开源内网文件管理器
- 原项目地址 https://filebrowser.org
- 下载地址 https://github.com/filebrowser/filebrowser/releases/


- 通常我使用这个软件来完成局域网传输文件。
正常情况下，每次使用的时候都要输入启动命令和参数来完成文件分享。为了方便，我将它加入到右键菜单栏中。您只需要对着你想要分享的目录，右键点击"Share by FileBrowser"即可！

# 如何使用
## S1.初次使用请使用管理员运行`install.bat`
它会将当前目录下的`fb.bat`添加到注册表。
当出现`Install successfully!`表示添加成功
## S2. 鼠标对着想要分享的文件，右键点击"Share By FileBrowser"
此时会打开一个终端，如果显示端口被占用，请手动关闭占用端口的程序

## S3. 在内网中的设备打开地址
如果你在本机上输入 http://localhost:8090 可以进入，那么其它内网的设备应该也没问题。（如果不能访问请排查防火墙和杀毒软件）


# 默认配置在run.bat
- 端口：8090
- 监听地址:0.0.0.0
- 无需授权访问:--noauth


# 如何卸载

- 使用管理员运行`uninstall.bat`，它会删除之前添加的注册表。当出现`Uninstall successfully!`表示删除注册表成功
- 然后手动把本目录下的所有文件删除即可。