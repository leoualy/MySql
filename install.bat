@echo off
echo ��������

:: ��Ȩ
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"

set root=%CD%


::���mysql���ݿ��Ƿ�����
@echo off
echo ���mysql�Ƿ�����
tasklist -v | findstr mysqld.exe > NUL
if ErrorLevel 1 (
  echo mysqlû������
  echo ����mysql
  call:startmysql
  ) else (
  echo mysql�Ѿ�����
  echo �ر�mysql
  call:stopmysql
  echo ����mysql
  call:startmysql
)

pause



::����mysql
:startmysql
cd %root%/mysql8/bin/
echo ��װmysql����
call mysqld -remove
call mysqld -install
echo ��ʼ��mysql 
echo ִ��--initialize-insecure   ��ʼroot����Ϊ�գ�����dataĿ¼
call mysqld --initialize-insecure
net start mysql
echo ִ��mysqladmin -u root password "root" ����root��ʼ���룺root
mysqladmin -u root password "root"
goto:eof

::�ر�mysql
:stopmysql
net stop mysql
goto:eof






