@echo off    
:set   
	

	
	:: Get the Blink length set by the user in yourblinklength.txt 
	set /p blinklength=<%~dp0\yourblinklengthkeyboard.txt

	:: Get the Hive node from hivenode.txt 
	set /p hivenode=<%~dp0\hivenode.txt
	
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

:: Let the user know, there is community activity (new post or votes/comments on it)  
	echo.
	echo %White%Blinkit new activity for %hiveusername% detected, %Green%Light blink! %White% 
	

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
	
	echo %White%

:: Download followers data from hive API and save it into a txt file
	 powershell Invoke-RestMethod -ContentType 'application/json' -Method Post -Uri https://api.hive.blog -Body %jsonbody% -UserAgent "curl" -OutFile %~dp0\data\downloadedfollowers.txt"
	
	 PING localhost -n 5 >NUL

	goto main