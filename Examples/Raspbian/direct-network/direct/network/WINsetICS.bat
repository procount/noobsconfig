@echo off
@setlocal enableextensions
@cd /d "%~dp0"
REM -------Version 1.0 June2013
REM -------Created by Tim Cox (meltwater)
REM -------www.pihardware.com
REM -------Free to use - must include above details.
set SOURCE=cmdline.internet
set TARGET=cmdline.txt
set DESC=direct with ICS (PC to RPi)
set INFO1=# MAKE SURE YOU UPDATE THE IP ADDRESSES IN cmdline.internet
set INFO2=# ip=A.B.C.10::A.B.C.D (where ABCD match the PC's
set INFO3=# network adaptor settings (AFTER ICS is enabled).
set IP1=# See new settings below for IP address ip=x.x.x.x::y.y.y.y
set IP2=# (where x is RPi and y is PC address)

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