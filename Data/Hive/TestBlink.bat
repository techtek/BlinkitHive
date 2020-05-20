@echo off
cls    
:set   
	
	:: Get the flashdrive letter set by the user in yourusbdrive.txt
	set /p flashdrive=<%~dp0\yourusbdrive.txt
	
	:: Get the Blink length set by the user in yourblinklength.txt 
	set /p blinklength=<%~dp0\yourblinklength.txt
	
	:: Get the Hive username from hiveusername.txt 
	set /p hiveusername=<%~dp0\hiveusername.txt
    
	:: Hive API request JSON
    set jsonbody='{\"jsonrpc\":\"2.0\", \"method\":\"condenser_api.get_blog\", \"params\":[\"%hiveusername%\",0,2], \"id\":1}' 
	
	
	
	:: Colour settings
	set ESC=
	set Red=%ESC%[91m
	set White=%ESC%[37m
	set Green=%ESC%[32m
	set Magenta=%ESC%[35m
	set Blue=%ESC%[94m
    set Grey=%ESC%[90m

:testblink
	set loop1=0
	:loop1
	xcopy %~dp0\data\ledfile.led %flashdrive%. /Y > nul
	set /a loop1=%loop1%+1 
	if "%loop1%"=="%blinklength%" goto menu
	goto loop1