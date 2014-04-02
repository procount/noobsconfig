@echo off
@setlocal enableextensions
@cd /d "%~dp0"
REM -------Version 1.0 June2013
REM -------Created by Tim Cox (meltwater)
REM -------www.pihardware.com
REM -------Free to use - must include above details.
set SOURCE=cmdline.direct
set TARGET=cmdline.txt
set DESC=direct (PC to RPi)
set INFO1=# Ensure the PC's network adaptor is set to auto/DHCP
set INFO2=# and internet connection sharing (ICS) is disabled.
set INFO3=
set IP1=# See below, ip=x.x.x.x will be the new address of the RPi

echo.### Setting Raspberry Pi network to %DESC% ###
echo.
echo.%INFO1%
echo.%INFO2%
echo.%INFO3%
echo.
echo.# Copy %SOURCE% to %TARGET%
copy %SOURCE% ..\%TARGET%
echo.
echo.%IP1%
echo.%IP2%
echo.# Contents of cmdline.txt:
type ..\cmdline.txt
echo.
pause