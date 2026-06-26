@echo off
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo Network Repair Log - %DATE% %TIME% >> "%LOGFILE%"

:: Apply uniform window scale for sub-module visibility
mode con: cols=65 lines=15

:: Standardize ANSI Color Codes safely without Delayed Expansion bugs
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "RESET=%ESC%[0m"

:: Define initial statuses
set "S1=%RED%[PENDING]%RESET%"
set "S2=%RED%[PENDING]%RESET%"
set "S3=%RED%[PENDING]%RESET%"

:REFRESH
cls
echo =================================================================
echo                    RUNNING NETWORK REPAIRS                       
echo =================================================================
echo  %S1% Resetting Network Adaptor Layers
echo  %S2% Releasing and Renewing IP Lease Configurations
echo  %S3% Flushing System DNS Resolver Cache
echo =================================================================

if "%S1%"=="%RED%[PENDING]%RESET%" (
    netsh winsock reset >> "%LOGFILE%" 2>&1
    netsh int ip reset >> "%LOGFILE%" 2>&1
    set "S1=%GREEN%[DONE]%RESET%"
    timeout /t 1 >nul
    goto REFRESH
)

if "%S2%"=="%RED%[PENDING]%RESET%" (
    ipconfig /release >> "%LOGFILE%" 2>&1
    ipconfig /renew >> "%LOGFILE%" 2>&1
    set "S2=%GREEN%[DONE]%RESET%"
    timeout /t 1 >nul
    goto REFRESH
)

if "%S3%"=="%RED%[PENDING]%RESET%" (
    ipconfig /flushdns >> "%LOGFILE%" 2>&1
    set "S3=%GREEN%[DONE]%RESET%"
    timeout /t 1 >nul
    goto REFRESH
)

echo.
echo Network diagnostics finalizing...
ping 8.8.8.8 -n 2 >> "%LOGFILE%" 2>&1
echo Returning to Master Dashboard...
timeout /t 2 >nul
exit /b
