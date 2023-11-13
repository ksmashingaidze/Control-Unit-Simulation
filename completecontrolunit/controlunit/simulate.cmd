@ECHO OFF

REM 	Simulation script to invoke Quartus simulator.
REM 	Workaround for when Quartus 9.1sp1 hangs when the 'simulate' button is pressed.
REM 	Usage: 	simulate.cmd <file_name.vwf> 
REM				Or double-click on the icon and type in <file_name.vwf>
REM 	Hacked together by Brad Kahn.

TITLE QSSSWP: Quartus Simulation Script for Silly Windows PCs

IF NOT "%1"=="" (
	SET file_name=%1
	)

:BEGIN

IF "%1"=="" (
	SET /p file_name="Enter the name of the vector waveform file ('<file_name.vwf>') you'd like to simulate:" 
	)

IF NOT %file_name:~-4% == .vwf (
	ECHO.
	ECHO ERROR: incorrect file type.
	ECHO You gave: '%file_name%'. Expecting: 'file_name.vwf'.
	GOTO BEGIN
	)
	
if NOT EXIST %file_name% (
	ECHO.
	ECHO ERROR: no file with name '%file_name%' found. 
	ECHO Full path: %~dp0%file_name%
	GOTO BEGIN
	)

:SIMULATE	

IF EXIST %file_name% (
	ECHO Vector waveform file found!, launching simulator... 
	C:\altera\91sp1\quartus\bin\quartus_sim.exe %file_name%
	ECHO.
	ECHO If all went well, simulation output should be available.
	ECHO In Quartus, open 'db\%file_name:~,-4%.sim.cvwf'.
	)

IF NOT "%1"=="" (
	GOTO END
	)

ECHO.
ECHO What do you want to do now? [1, 2, 3]
ECHO 1 - simulate '%file_name%' again.
ECHO 2 - select new vector waveform file.
ECHO 3 - quit.

SET /p option=

IF %option% == 1 GOTO SIMULATE
IF %option% == 2 GOTO BEGIN
REM IF %option% == 3 GOTO END
	
:END
PAUSE
