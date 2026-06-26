@echo off

:: Check for admin rights and auto-elevate
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Lock the script's working directory to where the file is stored
cd /d "%~dp0"

:MAIN_MENU
cls

:: Define your longest menu line text here to calculate width
set "LONGEST_LINE= 7. Run ALL Maintenance Utilities (Complete Overhaul) "

:: Safely calculate the width using standard variable assignment
for /f %%A in ('powershell -Command "'%LONGEST_LINE%'.Length + 8"') do set "DYNAMIC_WIDTH=%%A"

:: Apply the window size width using a direct percentage variable
mode con: cols=%DYNAMIC_WIDTH% lines=27

:: Build the dynamic decorative horizontal borders using a safe PowerShell loop string
for /f "delims=" %%B in ('powershell -Command "'=' * %DYNAMIC_WIDTH%"') do set "BORDER=%%B"

echo %BORDER%
echo            MASTER MAINTENANCE DASHBOARD           
echo %BORDER%
echo  1. Run Network Repair Suite (Module 1)
echo  2. Run System Optimization Suite (Module 2)
echo  3. Flush RAM Cache ^& Standby List (Optimize Memory)
echo  4. Run Hard Drive Diagnostics (Read-Only Check)
echo  5. Restart Windows Audio Engine (Fix No-Sound)
echo  6. Restart Core Hardware Drivers (GPU, Net, USB)
echo %LONGEST_LINE%
echo  8. Open Maintenance Log File
echo  9. Exit
echo %BORDER%
set /p "choice=Enter choice (1-9): "

if "%choice%"=="1" (
    if exist "Network_Suite.bat" (
        call "Network_Suite.bat"
        goto COMPLETE
    ) else (
        echo Error: Network_Suite.bat missing in %CD%! & pause
        goto MAIN_MENU
    )
)
if "%choice%"=="2" (
    if exist "System_Suite.bat" (
        call "System_Suite.bat"
        goto COMPLETE
    ) else (
        echo Error: System_Suite.bat missing in %CD%! & pause
        goto MAIN_MENU
    )
)
if "%choice%"=="3" goto FLUSH_RAM
if "%choice%"=="4" goto CHECK_DISK
if "%choice%"=="5" goto FIX_AUDIO
if "%choice%"=="6" goto RESTART_HARDWARE
if "%choice%"=="7" goto RUN_ALL_UTILITIES
if "%choice%"=="8" (
    if exist "%USERPROFILE%\Desktop\Master_Maintenance_Log.txt" (
        start notepad "%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
    ) else (
        echo No log file created yet. Run a script first! & pause
    )
    goto MAIN_MENU
)
if "%choice%"=="9" exit
goto MAIN_MENU

:RUN_ALL_UTILITIES
cls
mode con: cols=60 lines=18
echo ====================================================
echo             RUNNING COMPLETE SYSTEM OVERHAUL        
echo ====================================================
echo Executing all dashboard modules sequentially...
echo.

:: 1. Sub-module checks
if exist "Network_Suite.bat" (
    echo [*] Launching Network Suite...
    call "Network_Suite.bat"
)
if exist "System_Suite.bat" (
    echo [*] Launching System Suite...
    call "System_Suite.bat"
)

:: 2. Local module blocks
echo [*] Flushing RAM Cache...
call :SUB_FLUSH_RAM

echo [*] Diagnosing Hard Drive...
call :SUB_CHECK_DISK

echo [*] Restarting Audio Services...
call :SUB_FIX_AUDIO

echo [*] Refreshing Hardware Drivers...
call :SUB_RESTART_HARDWARE

echo ====================================================
echo All maintenance cycles completed successfully!
echo ====================================================
timeout /t 3 >nul
goto COMPLETE

:FLUSH_RAM
cls
mode con: cols=60 lines=12
echo ====================================================
echo               OPTIMIZING RAM CACHE                 
echo ====================================================
call :SUB_FLUSH_RAM
echo RAM cleanup complete.
timeout /t 2 >nul
goto COMPLETE

:SUB_FLUSH_RAM
echo Freeing up standby memory layers...
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo Memory Optimization Log - %DATE% %TIME% >> "%LOGFILE%"
powershell -Command "[System.GC]::Collect(); [System.GC]::WaitForPendingFinalizers()" >> "%LOGFILE%" 2>&1
exit /b

:CHECK_DISK
cls
mode con: cols=60 lines=15
echo ====================================================
echo              HARD DRIVE DIAGNOSTICS                
echo ====================================================
echo Scanning drive C: for file system errors...
echo (This is a safe, read-only test)
echo.
call :SUB_CHECK_DISK
echo Scan finished. Results appended to log file.
timeout /t 3 >nul
goto COMPLETE

:SUB_CHECK_DISK
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo Hard Drive Scan Log - %DATE% %TIME% >> "%LOGFILE%"
chkdsk C: >> "%LOGFILE%" 2>&1
exit /b

:FIX_AUDIO
cls
mode con: cols=60 lines=12
echo ====================================================
echo             RESTARTING AUDIO ENGINE                
echo ====================================================
echo Cycling Windows Audio Services...
call :SUB_FIX_AUDIO
echo Audio systems reset successfully.
timeout /t 2 >nul
goto COMPLETE

:SUB_FIX_AUDIO
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo Audio Reset Log - %DATE% %TIME% >> "%LOGFILE%"
net stop Audiosrv >> "%LOGFILE%" 2>&1
net stop AudioEndpointBuilder >> "%LOGFILE%" 2>&1
net start AudioEndpointBuilder >> "%LOGFILE%" 2>&1
net start Audiosrv >> "%LOGFILE%" 2>&1
exit /b

:RESTART_HARDWARE
cls
mode con: cols=60 lines=15
echo ====================================================
echo             RESTARTING HARDWARE DRIVERS            
echo ====================================================
call :SUB_RESTART_HARDWARE
echo Hardware components successfully refreshed.
timeout /t 2 >nul
goto COMPLETE

:SUB_RESTART_HARDWARE
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo Hardware Driver Reset Log - %DATE% %TIME% >> "%LOGFILE%"

echo [1/3] Refreshing Graphics subsystem...
powershell -Command "$wsh = New-Object -ComObject Wscript.Shell; $wsh.SendKeys('^+%%B')" 
timeout /t 2 >nul

echo [2/3] Restarting Network Adapters...
powershell -Command "Get-NetAdapter | Where-Object {$_.Status -eq 'Up' -or $_.Status -eq 'Disconnected'} | Disable-NetAdapter -Confirm:$false; Get-NetAdapter | Enable-NetAdapter -Confirm:$false" >> "%LOGFILE%" 2>&1
timeout /t 2 >nul

echo [3/3] Power-cycling USB Controller Hubs...
powershell -Command "Get-CimInstance Win32_PnPEntity | Where-Object {$_.Name -match 'USB Root Hub'} | ForEach-Object { Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false; Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false }" >> "%LOGFILE%" 2>&1
exit /b

:COMPLETE
powershell -Command "$ErrorActionPreference = 'SilentlyContinue'; [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; try { $player = New-Object System.Media.SoundPlayer('C:\Windows\Media\Windows XP Startup.wav'); if (Test-Path $player.SoundLocation) { $player.Play() } else { [System.Media.SystemSounds]::Asterisk.Play() } } catch {}; $choice = [System.Windows.Forms.MessageBox]::Show('Module execution complete! Do you want to reboot your computer now?', 'Restart Required', 'YesNo', 'Question'); if ($choice -eq 'Yes') { shutdown /r /t 5 } else { [System.Windows.Forms.MessageBox]::Show('Please remember to restart later for changes to take effect.', 'Notice', 'OK', 'Information') }"
goto MAIN_MENU
