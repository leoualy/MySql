@echo off
echo 环境部署

:: 提权
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"

set root=%CD%


::检查mysql数据库是否启动
@echo off
echo 检查mysql是否启动
tasklist -v | findstr mysqld.exe > NUL
if ErrorLevel 1 (
  echo mysql没有启动
  echo 启动mysql
  call:startmysql
  ) else (
  echo mysql已经启动
  echo 关闭mysql
  call:stopmysql
  echo 启动mysql
  call:startmysql
)

pause



::启动mysql
:startmysql
cd %root%/mysql8/bin/
echo 安装mysql服务
call mysqld -remove
call mysqld -install
echo 初始化mysql 
echo 执行--initialize-insecure   初始root密码为空，创建data目录
call mysqld --initialize-insecure
net start mysql
echo 执行mysqladmin -u root password "root" 设置root初始密码：root
mysqladmin -u root password "root"
goto:eof

::关闭mysql
:stopmysql
net stop mysql
goto:eof






