@echo off
set "LOGFILE=%USERPROFILE%\Desktop\Master_Maintenance_Log.txt"
echo System Optimization Log - %DATE% %TIME% >> "%LOGFILE%"

:: Fit the sub-module visual display scale comfortably
mode con: cols=65 lines=16

cls
echo =================================================================
echo                    RUNNING SYSTEM OPTIMIZATION                   
echo =================================================================
echo.
echo [1/3] Purging Temporary Caches ^& Windows Prefetch...
del /q /f /s "%TEMP%\*.*" >> "%LOGFILE%" 2>&1
del /q /f /s "C:\Windows\Temp\*.*" >> "%LOGFILE%" 2>&1
del /q /f /s "C:\Windows\Prefetch\*.*" >> "%LOGFILE%" 2>&1

echo [2/3] Validating Core System Component Image (DISM)...
echo (This may take a brief moment on custom OS builds...)
:: Appends to log, ignores internal catalog warnings common in Atlas/Revi
DISM /Online /Cleanup-Image /RestoreHealth >> "%LOGFILE%" 2>&1

echo [3/3] Integrity Scanning Protected System Files (SFC)...
sfc /scannow >> "%LOGFILE%" 2>&1

echo =================================================================
echo System optimization completed!
echo Returning to Master Dashboard...
echo =================================================================
timeout /t 2 >nul
exit /b
