@echo off
rem 功能：获取本地网卡网关地址

set p1=%~1
if %p1%.==. setlocal EnableDelayedExpansion

set "gw="
set isfind=0
set findgw=0
set findgwline=0
rem 获取活动连接网关地址
rem for /f "tokens=1* delims=:" %%a in ('ipconfig ^| findstr /R "[.]1$"') do set gw=%%b
for /f "skip=2 tokens=*" %%a in ('ipconfig') do (
rem for /f "skip=2 tokens=*" %%a in ('type C:\Users\sprite\Desktop\temp.txt') do (
	set line=%%a
	rem 找到第一个以太网/无线后查找ip，未找到则设置isfind=0
	REM echo findgw--!findgw! -- !findgwline!
	if !isfind! == 1 ( 
		for /f "tokens=1,2 delims=:" %%b in ('echo %%a ^| find /i "网关"') do (
			set tg=%%c
			set "tg=!tg: =!" 
			rem 设置变量并退出循环
			rem echo !line!
			REM if NOT !tg!.==. set gw=!tg! & goto endfor
			set findgw=1
			set /a findgwline=!findgwline!+1
		)
		
		echo !line! | find "适配器" > nul
		if !errorlevel! == 0 if !isfind!==1 set isfind=0
		rem echo !line! --- !isfind!
	)

	REM 读取包含“网关”字样开始的两行，解决存在IPv6网关时读取出错
	if !findgw! == 1 if !findgwline! LSS 2  (
		REM ipv6情况下匹配ipv4，即第2行ipv4
		REM 默认网关. . . . . . . . . . . . . : fe80::f6a5:9dff:feb2:53d0%9
		REM                                    192.168.3.1
		for /f %%d in ('echo !line! ^| findstr /b "\<[0-9][0-9]*^.[0-9][0-9]*"') do (
			set tg=%%d
			set "tg=!tg: =!" 
			if NOT !tg!.==. set gw=!tg! & goto endfor
		)

		REM 仅ipv4情况下匹配ipv4，单行
		REM 默认网关. . . . . . . . . . . . . : 192.168.3.1
		for /f "tokens=1,2 delims=:" %%e in ('echo !line! ^| findstr "\<192"') do (
			set tg=%%f
			set "tg=!tg: =!"
			echo !tg!
			if NOT !tg!.==. set gw=!tg! & goto endfor
		)

		REM 如果还匹配不到只能再见了
	)
	
	echo !line! | findstr /R "以太网 无线" > nul
	if !errorlevel! == 0 if !isfind!==0 set isfind=1
	if !errorlevel! == 0 if !findgw!==1 set findgw=0 & set findgwline=0
)

:endfor

rem 网络关获取失败，则手动输入
if "%gw%"=="" echo 网关获取失败 & ipconfig | find /i "ipv4" & echo.

:putgw
if "%gw%"=="" (
	set /p gw=请手动输入默认网关：
	if "%gw%"=="" goto putgw 
)


set gw=%gw: =%
echo 网关地址：%gw%

if %p1%.==. pause rem 双击运行，则暂停显示信息