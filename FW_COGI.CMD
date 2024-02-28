:-------------------------------------------------------------------------------------------
REM Haut 1.0
@echo off
cls
:-------------------------------------------------------------------------------------------
REM Demande d'admin 1.0.
:---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
echo Cogi // Getting administrator privileges.
goto Do_UAC
) else ( goto Get_Admin )
:---
REM
:Do_UAC
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B
:---
REM
:Get_Admin
pushd "%CD%"
CD /D "%~dp0"
:-------------------------------------------------------------------------------------------
call "LIBRARY/COLOR__WHITE_ON_DARK_BLUE.CMD"
:-------------------------------------------------------------------------------------------
REM CONFIGURATION FILE
:Direction
REM
for /f "eol=; delims=" %%C in (CONFIGURATION\DIRECTION.KJI) do (
set FW__Direction=%%C
)
REM
if %FW__Direction%==1 (
set FW__Enable_Out=yes
set FW__Enable_In=no
)
if %FW__Direction%==2 (
set FW__Enable_Out=no
set FW__Enable_In=yes
)
if %FW__Direction%==3 (
set FW__Enable_Out=yes
set FW__Enable_In=yes
)
REM
:-------------------------------------------------------------------------------------------
set KJI_Text_To_Display=Firewall
:-------------------------------------------------------------------------------------------
REM
:QueryNumber1
cls
call "LIBRARY/DISPLAY__COGI.CMD"
echo.
REM
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
echo -----------------------------------------------------------
echo 1. Set firewall to OFF
echo 2. Set firewall to ON
echo 3. Create allow rules for port 53 TCP and UDP
echo 4. Set firewall to OFF and then to ON
echo 5. Create allow rules for a specified port TCP
echo 6. Create allow rules for a specified port UDP
echo 7. Create allow rules for a specified port TCP and UDP
echo -----------------------------------------------------------
REM
set /P FW__Where_To_Go="?"
REM
if %FW__Where_To_Go%==1 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==2 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==3 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==4 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==5 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==6 (set FW__Query1_Validated=1)
if %FW__Where_To_Go%==7 (set FW__Query1_Validated=1)
REM
if [%FW__Query1_Validated%] == [] (
goto :QueryNumber1 )
REM
:-------------------------------------------------------------------------------------------
REM
:QueryNumber2
cls
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
if %FW__Where_To_Go%==1 (echo OK: Set firewall to OFF )
if %FW__Where_To_Go%==2 (echo OK: Set firewall to ON)
if %FW__Where_To_Go%==3 (echo OK: Create allow rules for port 53 TCP and UDP)
if %FW__Where_To_Go%==4 (echo OK: Set firewall to OFF and then to ON )
if %FW__Where_To_Go%==5 (echo OK: Create allow rules for a specified port TCP)
if %FW__Where_To_Go%==6 (echo OK: Create allow rules for a specified port UDP)
if %FW__Where_To_Go%==7 (echo OK: Create allow rules for a specified port TCP and UDP)
REM
echo ------------------
echo 1. Domain profile
echo 2. Private profile
echo 3. Public profile
echo 4. Both profiles
echo 5. [..] Go back
echo ------------------
REM
set /P FW__What_Profile="?"
REM
if %FW__What_Profile%==1 (
set FW__Query2_Validated=1
set FW__Profile_Setting1=domainprofile
set FW__Profile_Setting2=domain
set FW__Profile_Setting3=DOMAIN PROFILE
)
REM
if %FW__What_Profile%==2 (
set FW__Query2_Validated=1
set FW__Profile_Setting1=privateprofile
set FW__Profile_Setting2=private
set FW__Profile_Setting3=PRIVATE PROFILE
)
REM
if %FW__What_Profile%==3 (
set FW__Query2_Validated=1
set FW__Profile_Setting1=publicprofile
set FW__Profile_Setting2=public
set FW__Profile_Setting3=PUBLIC PROFILE
)
REM
if %FW__What_Profile%==4 (
set FW__Query2_Validated=1
set FW__Profile_Setting1=bothprofiles
set FW__Profile_Setting2=domain,private,public
set FW__Profile_Setting3=BOTH PROFILES
)
REM
if %FW__What_Profile%==5 (
goto QueryNumber1 )
REM
if [%FW__Query2_Validated%] == [] (
goto QueryNumber2 )
REM
:-------------------------------------------------------------------------------------------
REM
if %FW__Where_To_Go%==1 (goto :FirewallOff)
if %FW__Where_To_Go%==2 (goto :FirewallOn)
if %FW__Where_To_Go%==3 (goto :Port53TcpUdp)
if %FW__Where_To_Go%==4 (goto :FirewallDynamic)
if %FW__Where_To_Go%==5 (goto :SpecifiedPortTcp)
if %FW__Where_To_Go%==6 (goto :SpecifiedPortUdp)
if %FW__Where_To_Go%==7 (goto :SpecifiedPortTcpUdp)
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallOff
cls
echo ------------------------------... .. .
echo Cogi // SET FIREWALL TO OFF // %FW__Profile_Setting3%
echo ------------------------------... .. .
if %FW__Profile_Setting1%==bothprofiles (goto :FirewallOffBoth)
netsh advfirewall set %FW__Profile_Setting1% state off
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallOffBoth
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallOn
cls
echo -----------------------------... .. .
echo Cogi // SET FIREWALL TO ON // %FW__Profile_Setting3%
echo -----------------------------... .. .
if %FW__Profile_Setting1%==bothprofiles (goto :FirewallOnBoth)
netsh advfirewall set %FW__Profile_Setting1% state on
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallOnBoth
netsh advfirewall set domainprofile state on
netsh advfirewall set privateprofile state on
netsh advfirewall set publicprofile state on
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:Port53TcpUdp
cls
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
echo -----------------------------------------------------... .. .
echo Cogi // CREATE ALLOW RULES FOR PORT 53 TCP AND UDP // %FW__Profile_Setting3%
echo -----------------------------------------------------... .. .
REM
netsh advfirewall firewall add rule name="-= PORT 53 (DNS) / OUT / TCP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="53"
netsh advfirewall firewall add rule name="-= PORT 53 (DNS) / IN / TCP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="53"
REM
netsh advfirewall firewall add rule name="-= PORT 53 (DNS) / OUT / UDP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="53"
netsh advfirewall firewall add rule name="-= PORT 53 (DNS) / IN / UDP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="53"
REM
wf.msc
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallDynamic
cls
echo --------------------------------------------- ... .. .
echo Cogi // SET FIREWALL TO OFF AND THEN TO ON // %FW__Profile_Setting3%
echo --------------------------------------------- ... .. .
if %FW__Profile_Setting1%==bothprofiles (goto :FirewallDynamicBoth)
REM
netsh advfirewall set %FW__Profile_Setting1% state off
echo FIREWALL OF %FW__Profile_Setting3% IS NOW SET TO OFF
echo ENTER 'fo' TO SET FIREWALL OF %FW__Profile_Setting3% TO ON
netsh advfirewall set %FW__Profile_Setting1% state on
REM
set /P FW__Issue1="?"
if %FW__Issue1%==fo (goto :Next1)
goto :FirewallDynamic
:Next1
REM
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:FirewallDynamicBoth
cls
netsh advfirewall set domainprofile state off
netsh advfirewall set privateprofile state off
netsh advfirewall set publicprofile state off
echo ALL FIREWALLS PROFILES ARE NOW SET TO OFF
echo ENTER 'fo', TO SET ALL FIREWALLS PROFILES TO ON
REM
set /P FW__Issue2="?"
if %FW__Issue2%==fo (goto :Next2)
goto :FirewallDynamicBoth
:Next2
REM
netsh advfirewall set domainprofile state on
netsh advfirewall set privateprofile state on
netsh advfirewall set publicprofile state on
firewall.cpl
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:SpecifiedPortTcp
cls
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
echo ------------------------------------------------------... .. .
echo Cogi // CREATE ALLOW RULES FOR A SPECIFIED PORT TCP // %FW__Profile_Setting3%
echo ------------------------------------------------------... .. .
REM
set /P FW__What_Tcp_Port="?"
REM
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Port% / OUT / TCP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="%FW__What_Tcp_Port%"
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Port% / IN / TCP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="%FW__What_Tcp_Port%"
wf.msc
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:SpecifiedPortUdp
cls
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
echo ------------------------------------------------------... .. .
echo Cogi // CREATE ALLOW RULES FOR A SPECIFIED PORT UDP // %FW__Profile_Setting3%
echo ------------------------------------------------------... .. .
REM
set /P FW__What_Udp_Port="?"
REM
netsh advfirewall firewall add rule name="-= PORT %FW__What_Udp_Port% / OUT / UDP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="%FW__What_Udp_Port%"
netsh advfirewall firewall add rule name="-= PORT %FW__What_Udp_Port% / IN / UDP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="%FW__What_Udp_Port%"
wf.msc
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:SpecifiedPortTcpUdp
cls
call "LIBRARY/DISPLAY__CONFIGURATION.CMD"
echo ------------------------------------------------------... .. .
echo Cogi // CREATE ALLOW RULES FOR A SPECIFIED PORT TCP AND UDP // %FW__Profile_Setting3%
echo ------------------------------------------------------... .. .
REM
set /P FW__What_Tcp_Udp_Port="?"
REM
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Udp_Port% / OUT / TCP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="%FW__What_Tcp_Udp_Port%"
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Udp_Port% / IN / TCP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="TCP" remoteport="%FW__What_Tcp_Udp_Port%"
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Udp_Port% / OUT / UDP / %FW__Profile_Setting3% =-" dir="out" action="allow" enable="%FW__Enable_Out%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="%FW__What_Tcp_Udp_Port%"
netsh advfirewall firewall add rule name="-= PORT %FW__What_Tcp_Udp_Port% / IN / UDP / %FW__Profile_Setting3% =-" dir="in" action="allow" enable="%FW__Enable_In%" profile="%FW__Profile_Setting2%" protocol="UDP" remoteport="%FW__What_Tcp_Udp_Port%"
wf.msc
goto :Exit
REM
:-------------------------------------------------------------------------------------------
REM
:Exit
call "LIBRARY/COLOR__WHITE_ON_GREEN.CMD"
cmd