@echo off
@setlocal enableextensions
@cd /d "%~dp0"
REM -------Version 1.0 June2013
REM -------Created by Tim Cox (meltwater)
REM -------www.pihardware.com
REM -------Free to use - must include above details.
set SOURCE=cmdline.normal
set TARGET=cmdline.txt
set DESC=automatic DHCP
set INFO1=# Connect RPi to DHCP enabled router or similar
set INFO2=
set INFO3=
set IP1=# Use hostname -I on RPi to find IP address allocated
set IP2=

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