@echo off
rem ���ܣ���ȡ�����������ص�ַ

set p1=%~1
if %p1%.==. setlocal EnableDelayedExpansion

set "gw="
set isfind=0
set findgw=0
set findgwline=0
rem ��ȡ��������ص�ַ
rem for /f "tokens=1* delims=:" %%a in ('ipconfig ^| findstr /R "[.]1$"') do set gw=%%b
for /f "skip=2 tokens=*" %%a in ('ipconfig') do (
rem for /f "skip=2 tokens=*" %%a in ('type C:\Users\sprite\Desktop\temp.txt') do (
	set line=%%a
	rem �ҵ���һ����̫��/���ߺ����ip��δ�ҵ�������isfind=0
	REM echo findgw--!findgw! -- !findgwline!
	if !isfind! == 1 ( 
		for /f "tokens=1,2 delims=:" %%b in ('echo %%a ^| find /i "����"') do (
			set tg=%%c
			set "tg=!tg: =!" 
			rem ���ñ������˳�ѭ��
			rem echo !line!
			REM if NOT !tg!.==. set gw=!tg! & goto endfor
			set findgw=1
			set /a findgwline=!findgwline!+1
		)
		
		echo !line! | find "������" > nul
		if !errorlevel! == 0 if !isfind!==1 set isfind=0
		rem echo !line! --- !isfind!
	)

	REM ��ȡ���������ء�������ʼ�����У��������IPv6����ʱ��ȡ����
	if !findgw! == 1 if !findgwline! LSS 2  (
		REM ipv6�����ƥ��ipv4������2��ipv4
		REM Ĭ������. . . . . . . . . . . . . : fe80::f6a5:9dff:feb2:53d0%9
		REM                                    192.168.3.1
		for /f %%d in ('echo !line! ^| findstr /b "\<[0-9][0-9]*^.[0-9][0-9]*"') do (
			set tg=%%d
			set "tg=!tg: =!" 
			if NOT !tg!.==. set gw=!tg! & goto endfor
		)

		REM ��ipv4�����ƥ��ipv4������
		REM Ĭ������. . . . . . . . . . . . . : 192.168.3.1
		for /f "tokens=1,2 delims=:" %%e in ('echo !line! ^| findstr "\<192"') do (
			set tg=%%f
			set "tg=!tg: =!"
			echo !tg!
			if NOT !tg!.==. set gw=!tg! & goto endfor
		)

		REM �����ƥ�䲻��ֻ���ټ���
	)
	
	echo !line! | findstr /R "��̫�� ����" > nul
	if !errorlevel! == 0 if !isfind!==0 set isfind=1
	if !errorlevel! == 0 if !findgw!==1 set findgw=0 & set findgwline=0
)

:endfor

rem ����ػ�ȡʧ�ܣ����ֶ�����
if "%gw%"=="" echo ���ػ�ȡʧ�� & ipconfig | find /i "ipv4" & echo.

:putgw
if "%gw%"=="" (
	set /p gw=���ֶ�����Ĭ�����أ�
	if "%gw%"=="" goto putgw 
)


set gw=%gw: =%
echo ���ص�ַ��%gw%

if %p1%.==. pause rem ˫�����У�����ͣ��ʾ��Ϣ