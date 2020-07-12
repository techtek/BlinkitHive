@echo off    
:set   
	
	:: Get the Hive username from hiveusername.txt 
	set /p ip=<%~dp0\yourtasmotaip.txt
	
	:: Get the Blink length set by the user in yourblinklength.txt 
	set /p blinklength=<%~dp0\yourblinklengthtasmota.txt
	
	:: Get the hive username from hiveusername.txt 
	set /p hiveusername=<%~dp0\hiveusername.txt
    
	:: Hive API request JSON
    set jsonbody='{\"jsonrpc\":\"2.0\", \"method\":\"bridge.account_notifications\", \"params\":{\"account\":\"%hiveusername%\",\"limit\":1}, \"id\":1}' 
		
	
	
	:: Colour settings
	set ESC=
	set Red=%ESC%[91m
	set White=%ESC%[37m
	set Green=%ESC%[32m
	set Magenta=%ESC%[35m
	set Blue=%ESC%[94m
    set Grey=%ESC%[90m

 
  
  
  
   
:start

   
:: Display welcome message to the user welcome.txt      
	type %~dp0\data\welcome.txt

	
:: Let the user know that Blinkit is going to watch for new notifications by displaying the text:
	echo %Red%Hive %Grey%account notification streamer %Grey%
	echo.
	echo %Grey%Hive username: %hiveusername%
    echo.

	
:: Let the user know the Tasmota device ip that is set 	  
	echo %Grey%Your Tasmota device IP: %ip%
	echo.

:: Blink the light, by requesting the Tasmota toggle url
	echo %Grey%Testing Tasmota Device Blink... 
	powershell.exe -noprofile -command "Invoke-WebRequest -Uri %ip%" >NUL
	powershell.exe -noprofile -command "Invoke-WebRequest -Uri %ip%" >NUL
	echo.
	
:: Let the user know a sound is being played by displaying the text:
	echo %Grey%Testing Notification Sound...%White%
	
:: Play and test windows notification sound	
	powershell -c echo `a	

:: let the user know that the program is starting
	echo.
	echo %White%Blinkit is now connecting your Tasmota device to the %Red%Hive%White% Blockchain...	 	  
	echo.
	
:: Blinkit Script 

:: Download data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadednotifications.txt"
	PING localhost -n 4 >NUL
	

:main   
:: Download data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadednotifications2.txt"
	 PING localhost -n 4 >NUL

    	
:: Compare the 2 downloaded txt files if different go to "notification", if the files are the same go to "next" 
    fc %~dp0\data\downloadednotifications.txt %~dp0\data\downloadednotifications2.txt > nul
	if errorlevel 1 goto notification 
	if errorlevel 0 goto next
		
		
:next
:: let the user know the program is running by displaying the text:  
	echo.
	echo %White%Blinkit is running...
	

	
:: Download data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadednotifications2.txt"
	

	 :: 8 seconds silent delay (works by pinging local host)
	 PING localhost -n 7 >NUL
	
	goto main

	
    
:notification

:: Let the user know, there is a new notification! by displaying the text:   
	echo .
	echo Blinkit %White%new notification for %Red%Hive %White%user %hiveusername% detected, %Green%Light blink! %White% 
	echo.
	
	:: Remove unwanted characters from the downloaded data
	powershell -Command "(gc %~dp0\data\downloadednotifications2.txt) -replace '""', ' ' | Set-Content %~dp0\data\downloadednotifications2.txt -Force
		PING localhost -n 1 >NUL
	powershell -Command "(gc %~dp0\data\downloadednotifications2.txt) -replace '\s*.+msg' | Set-Content %~dp0\data\downloadednotifications2.txt -Force
		PING localhost -n 1 >NUL
	powershell -Command "(gc %~dp0\data\downloadednotifications2.txt) -replace ':', ' ' | Set-Content %~dp0\data\downloadednotifications2.txt -Force
		PING localhost -n 1 >NUL
	powershell -Command "(gc %~dp0\data\downloadednotifications2.txt) -replace '..........$' | Set-Content %~dp0\data\downloadednotifications2.txt -Force
		PING localhost -n 1 >NUL

	
	echo Notification: 
	type %~dp0\data\downloadednotifications2.txt	

:: Blink the Tasmota device
    START /MIN CMD.EXE /C %~dp0\TestBlinkTasmota.bat  goto sound
	
	
:sound	
	
:: Play windows notification sound
    powershell -c echo `a 	
	
	echo %White%

:: Download data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadednotifications.txt"
	
	 PING localhost -n 5 >NUL

	goto main