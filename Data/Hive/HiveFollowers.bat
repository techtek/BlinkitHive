@echo off    
:set   
	
	:: Get the flashdrive letter set by the user in yourusbdrive.txt
	set /p flashdrive=<%~dp0\yourusbdrive.txt
	
	:: Get the Blink length set by the user in yourblinklength.txt 
	set /p blinklength=<%~dp0\yourblinklength.txt
	
	:: Get the hive username from hiveusername.txt 
	set /p hiveusername=<%~dp0\hiveusername.txt
    
	:: Hive API request JSON
    set jsonbody='{\"jsonrpc\":\"2.0\", \"method\":\"condenser_api.get_followers\", \"params\":[\"%hiveusername%\",null,\"blog\",10], \"id\":1}' 
	
	
	
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

	
:: Let the user know that Blinkit is going to watch for new followers by displaying the text:
	echo %Red%Hive account followers
	echo.
	echo %Grey%Hive username: %hiveusername%
    echo.
	  
:: Let the user know the led is going to be blinked, on the %flashdrive% letter by displaying the text:  	  
	echo %Grey%Your USB Flash Drive: %flashdrive%
	echo.

:: Blink the LED, by copying the LED file from the Blinkit folder to the flashdrive
	echo %Grey%Testing LED Blink... 
	xcopy %~dp0\data\ledfile.led %flashdrive%. /Y > nul 
	echo.
	
:: Let the user know a sound is being played by displaying the text:
	echo %Grey%Testing Notification Sound...%White%
	
:: Play and test windows notification sound	
	powershell -c echo `a	

:: Display the saved Username and Flash drive letter and let the user know that the program is starting to look for new Followers
	echo.
	echo %White%Blinkit is now connecting your USB flash drive to the %Red%Hive%White% Blockchain...	  
	echo.
	
:: Blinkit Followers Script 

:: Download followers data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadedfollowers.txt"
	PING localhost -n 4 >NUL
	

:main   
:: Download followers data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadedfollowers2.txt"
	 PING localhost -n 4 >NUL

    	
:: Compare the 2 downloaded follower txt files if different go to "notification", if the files are the same go to "next" 
    fc %~dp0\data\downloadedfollowers.txt %~dp0\data\downloadedfollowers2.txt > nul
	if errorlevel 1 goto notification 
	if errorlevel 0 goto next
		
		
:next
:: let the user know the program is running by displaying the text:  
	echo.
	echo %White%Blinkit is running...
	

	
:: Download followers data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadedfollowers2.txt"
	

	 :: 8 seconds silent delay (works by pinging local host)
	 PING localhost -n 7 >NUL
	
	goto main

	
    
:notification

:: Let the user know, there is a new follower! by displaying the text:   
	echo .
	echo Blinkit %White%New follower for %Red%Hive %White%user %hiveusername% detected, %Green%Light blink! %White% 
	

:: Let the user know, there is a new Follower, and blink the LED by copying the LED file to the flash drive 
    	
	set loop=0
	:loop
	xcopy %~dp0\data\ledfile.led %flashdrive%. /Y > nul
	set /a loop=%loop%+1 
	if "%loop%"=="%blinklength%" goto sound
	goto loop

	:sound
	
	
	
	
:: Play windows notification sound
    powershell -c echo `a 	
	
	echo %White%

:: Download followers data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadedfollowers.txt"
	
	 PING localhost -n 5 >NUL

	goto main