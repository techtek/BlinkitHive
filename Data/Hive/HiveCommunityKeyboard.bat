@echo off
cls    
:set   
	
	:: Get the Blink length set by the user in yourblinklength.txt 
	set /p blinklength=<%~dp0\yourblinklengthkeyboard.txt
	
	:: Get the Hive node from hivenode.txt 
	set /p hivenode=<%~dp0\hivenode.txt
	
		:: Get the hive username from hiveusername.txt 
	set /p hiveusername=<%~dp0\hiveusername.txt
    
			:: Get the Hive node from hivenode.txt 
	set /p hivecommunity=<%~dp0\hivecommunity.txt
	
	:: Hive API request JSON
    set jsonbody='{\"jsonrpc\":\"2.0\", \"method\":\"condenser_api.get_discussions_by_created\", \"params\":[{\"tag\":\"%hivecommunity%\",\"limit\":1}], \"id\":1}' 
	
	
	              
	
	:: Colour settings
	set ESC=
	set Red=%ESC%[91m
	set White=%ESC%[37m
	set Green=%ESC%[32m
	set Magenta=%ESC%[35m
	set Blue=%ESC%[94m
    set Grey=%ESC%[90m

  



  
  
  
  
  
   
:start
cls
   
:: Display welcome message to the user welcome.txt      
	type %~dp0\data\welcome.txt

	
:: Let the user know that Blinkit is going to watch for new community posts and votes
	echo %Grey%Blink on new %hivecommunity% community posts and votes  %Grey%(limit is latest post)
	echo.
	  
:: Let the user know the led is going to be blinked, on the %flashdrive% letter by displaying the text:  	  
	echo %Grey%Hive Node %hivenode%
	echo.	

:: Test blink the lights of the keyboard
	echo %Grey%Testing the keyboards Caps, Scroll, Numlock lights... 	
	START /MIN CMD.EXE /C %~dp0\TestBlinkKeyboard.vbs 
	echo.
	
:: Let the user know a sound is being played by displaying the text:
	echo %Grey%Testing Notification Sound...%White%
	
:: Play and test windows notification sound	
	powershell -c echo `a	

:: let the user know blinkit is connecting 
	echo.
	echo %White%Blinkit is now connecting your Keyboard lights to the %Red%Hive%White% Blockchain...	  
	echo.
	
:: Blinkit Community Script 

:: Download new community data from Hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri %hivenode% -Body %jsonbody% -UserAgent "curl" -OutFile  %~dp0\data\downloadedpostvotes.txt"
	PING localhost -n 4 >NUL
	

:main   
:: Download Community data from Hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri %hivenode% -Body %jsonbody% -UserAgent "curl" -OutFile  %~dp0\data\downloadedpostvotes2.txt"
	 PING localhost -n 4 >NUL

    	
:: Compare the 2 downloaded post votes txt files if different go to "notification", if the files are the same go to "next" 
    fc  %~dp0\data\downloadedpostvotes.txt  %~dp0\data\downloadedpostvotes2.txt > nul
	if errorlevel 1 goto notification 
	if errorlevel 0 goto next
		
		
:next
:: let the user know the program is running by displaying the text:  
	echo.
	echo %White%Blinkit is running...
	

	
:: Download community data from Hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri %hivenode% -Body %jsonbody% -UserAgent "curl" -OutFile  %~dp0\data\downloadedpostvotes2.txt"
	

	 :: 8 seconds silent delay (works by pinging local host)
	 PING localhost -n 7 >NUL
	
	goto main

	
    
    
:notification

:: Let the user know, there is community activity (new post or votes/comments on it)  
	echo.
	echo %White%Blinkit new %hivecommunity% community activity detected, %Green%Light blink! %White% 
	

:: Blink the keyboards (caps, scroll and Numlock) lights
    

	set loop=0
	:loop
	START /MIN CMD.EXE /C %~dp0\TestBlinkKeyboard.vbs > nul
	set /a loop=%loop%+1 
	PING localhost -n 7 >NUL
	if "%loop%"=="%blinklength%" goto sound
	goto loop
	
	
	
:sound	
	
	
:: Play windows notification sound
    powershell -c echo `a 	
	


:: Download postvotes data from Hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri %hivenode% -Body %jsonbody% -UserAgent "curl" -OutFile  %~dp0\data\downloadedpostvotes.txt"
	
	 PING localhost -n 5 >NUL

	goto main