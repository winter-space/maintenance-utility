@echo off
setlocal EnabledDelayedExpansion

:: Check for admin rights and auto-elevate
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set up log file on Desktop
set "LOGFILE=%USERPROFILE%\Desktop\Network_Fix_Log.txt"
echo Network Repair Log - %DATE% %TIME% > "%LOGFILE%"
echo =================================== >> "%LOGFILE%"

:: ANSI Color Codes
set "ESC="
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "RESET=%ESC%[0m"

:: Initialize status variables
set "S1=%RED%[PENDING]%RESET%"
set "S2=%RED%[PENDING]%RESET%"
set "S3=%RED%[PENDING]%RESET%"
set "S4=%RED%[PENDING]%RESET%"
set "S5=%RED%[PENDING]%RESET%"

:MENU
cls
echo ===============================================
echo             NETWORK REPAIR UTILITY             
echo ===============================================
echo  1. Run ALL Network Fixes (Recommended)
echo  2. Select Individual Repairs
echo  3. Exit
echo ===============================================
set /p "choice=Enter your choice (1-3): "

if "%choice%"=="1" goto RUN_ALL
if "%choice%"=="2" goto SELECT_INDIVIDUAL
if "%choice%"=="3" exit
goto MENU

:SELECT_INDIVIDUAL
cls
echo ===============================================
echo          SELECT INDIVIDUAL REPAIRS             
echo ===============================================
echo  1. Reset Winsock Catalogs
echo  2. Reset TCP/IP Stack
echo  3. Release IP Address
echo  4. Renew IP Address
echo  5. Flush DNS Cache
echo  6. Back to Main Menu
echo ===============================================
set /p "subchoice=Enter your choice (1-6): "

if "%subchoice%"=="1" goto RUN_SINGLE_1
if "%subchoice%"=="2" goto RUN_SINGLE_2
if "%subchoice%"=="3" goto RUN_SINGLE_3
if "%subchoice%"=="4" goto RUN_SINGLE_4
if "%subchoice%"=="5" goto RUN_SINGLE_5
if "%subchoice%"=="6" goto MENU
goto SELECT_INDIVIDUAL

:RUN_ALL
call :SHOW_PROGRESS
timeout /t 1 >nul
netsh winsock reset >> "%LOGFILE%" 2>&1
set "S1=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
netsh int ip reset >> "%LOGFILE%" 2>&1
set "S2=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /release >> "%LOGFILE%" 2>&1
set "S3=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /renew >> "%LOGFILE%" 2>&1
set "S4=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /flushdns >> "%LOGFILE%" 2>&1
set "S5=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
goto COMPLETE

:RUN_SINGLE_1
set "S2=---" & set "S3=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & netsh winsock reset >> "%LOGFILE%" 2>&1
set "S1=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_2
set "S1=---" & set "S3=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & netsh int ip reset >> "%LOGFILE%" 2>&1
set "S2=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_3
set "S1=---" & set "S2=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & ipconfig /release >> "%LOGFILE%" 2>&1
set "S3=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_4
set "S1=---" & set "S2=---" & set "S3=---" & set "S5=---"
call :SHOW_PROGRESS & ipconfig /renew >> "%LOGFILE%" 2>&1
set "S4=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_5
set "S1=---" & set "S2=---" & set "S3=---" & set "S4=---"
call :SHOW_PROGRESS & ipconfig /flushdns >> "%LOGFILE%" 2>&1
set "S5=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:SHOW_PROGRESS
cls
echo ===============================================
echo                REPAIR PROGRESS                 
echo ===============================================
echo  %S1% Resetting Winsock Catalogs
echo  %S2% Resetting TCP/IP Stack
echo  %S3% Releasing IP Address
echo  %S4% Renewing IP Address
echo  %S5% Flushing DNS Cache
echo ===============================================
exit /b

:COMPLETE
echo.
echo Finishing diagnostics...
ping 8.8.8.8 -n 2 >> "%LOGFILE%" 2>&1

:: Plays the classic Windows XP sound and shows the prompt window simultaneously
powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $player = New-Object System.Media.SoundPlayer('C:\Windows\Media\Windows XP Startup.wav'); if (Test-Path $player.SoundLocation) { $player.Play() } else { [System.Media.SystemSounds]::Asterisk.Play() }; $choice = [System.Windows.Forms.MessageBox]::Show('Network repairs complete! Do you want to reboot your computer now?', 'Restart Required', 'YesNo', 'Question'); if ($choice -eq 'Yes') { shutdown /r /t 5 } else { [System.Windows.Forms.MessageBox]::Show('Please remember to restart later for changes to take effect.', 'Notice', 'OK', 'Information') }"
exit

call :SHOW_PROGRESS
timeout /t 1 >nul
netsh winsock reset >> "%LOGFILE%" 2>&1
set "S1=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
netsh int ip reset >> "%LOGFILE%" 2>&1
set "S2=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /release >> "%LOGFILE%" 2>&1
set "S3=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /renew >> "%LOGFILE%" 2>&1
set "S4=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
timeout /t 1 >nul
ipconfig /flushdns >> "%LOGFILE%" 2>&1
set "S5=%GREEN%[DONE]%RESET%"

call :SHOW_PROGRESS
goto COMPLETE

:RUN_SINGLE_1
set "S2=---" & set "S3=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & netsh winsock reset >> "%LOGFILE%" 2>&1
set "S1=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_2
set "S1=---" & set "S3=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & netsh int ip reset >> "%LOGFILE%" 2>&1
set "S2=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_3
set "S1=---" & set "S2=---" & set "S4=---" & set "S5=---"
call :SHOW_PROGRESS & ipconfig /release >> "%LOGFILE%" 2>&1
set "S3=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_4
set "S1=---" & set "S2=---" & set "S3=---" & set "S5=---"
call :SHOW_PROGRESS & ipconfig /renew >> "%LOGFILE%" 2>&1
set "S4=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:RUN_SINGLE_5
set "S1=---" & set "S2=---" & set "S3=---" & set "S4=---"
call :SHOW_PROGRESS & ipconfig /flushdns >> "%LOGFILE%" 2>&1
set "S5=%GREEN%[DONE]%RESET%" & call :SHOW_PROGRESS & goto COMPLETE

:SHOW_PROGRESS
cls
echo ===============================================
echo                REPAIR PROGRESS                 
echo ===============================================
echo  %S1% Resetting Winsock Catalogs
echo  %S2% Resetting TCP/IP Stack
echo  %S3% Releasing IP Address
echo  %S4% Renewing IP Address
echo  %S5% Flushing DNS Cache
echo ===============================================
exit /b

:COMPLETE
echo.
echo Finishing diagnostics...
ping 8.8.8.8 -n 2 >> "%LOGFILE%" 2>&1

:: Plays the classic Windows XP sound and shows the prompt window simultaneously
powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; $player = New-Object System.Media.SoundPlayer('C:\Windows\Media\Windows XP Startup.wav'); if (Test-Path $player.SoundLocation) { $player.Play() } else { [System.Media.SystemSounds]::Asterisk.Play() }; $choice = [System.Windows.Forms.MessageBox]::Show('Network repairs complete! Do you want to reboot your computer now?', 'Restart Required', 'YesNo', 'Question'); if ($choice -eq 'Yes') { shutdown /r /t 5 } else { [System.Windows.Forms.MessageBox]::Show('Please remember to restart later for changes to take effect.', 'Notice', 'OK', 'Information') }"
exit
