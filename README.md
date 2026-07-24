# 🛠️ All-in-One PC Maintenance Suite v1.5.0

A modular batch script framework to repair networks, optimize memory, clear caches, and refresh hardware drivers. Built to work on stock Windows as well as optimized custom builds like **ReviOS** and **AtlasOS**.

## 🚀 Key Features
* **Preflight System Check:** Validates admin privileges, RAM, disk space, network connectivity, and detects conflicting processes
* **Auto-Scaling Window:** Automatically resizes the command window to fit the text perfectly
* **Network Repairs:** Resets Winsock, IP leases, and DNS with color-coded status tracking
* **System Optimization:** Safe cleanup of Temp/Prefetch files alongside SFC and DISM scans
* **Hardware Refresh:** Restarts GPU drivers, network adapters, and USB controller hubs on the fly
* **Comprehensive Logging:** All operations logged to `System_Maintenance_Log.txt` on Desktop with timestamps
* **Error Handling:** Robust error handling for locked files, null values, and custom OS detection
* **Debug Mode:** Toggle debug mode for verbose output and troubleshooting
* **XP Chime Notification:** Plays the classic Windows XP sound on completion with reboot prompt

## 📦 How to Use

1. Download the zip file and **export it**

2. Run `Master_Launcher.bat` (it will automatically request Admin rights)

3. Choose your option from the menu:
   - **1:** Run Preflight System Check (diagnostics only)
   - **2-7:** Run individual repair modules
   - **8:** Run all utilities sequentially (complete overhaul)
   - **9:** Open maintenance logs folder
   - **10:** Toggle debug mode
   - **11:** Exit

## 📋 What Each Module Does

### Preflight_Check.bat
Validates system readiness before maintenance:
- ✅ Administrator privileges verification
- 💾 Available disk space detection
- 🧠 System RAM detection
- 🌐 Internet connectivity test
- ⚠️ Conflicting process detection (Windows Update, Antivirus, Defrag)

### Network_Suite.bat
- Resets Winsock catalog
- Resets TCP/IP stack
- Releases and renews IP lease
- Flushes DNS cache
- Tests connectivity to 8.8.8.8

### System_Suite.bat
- Clears `%TEMP%` folder
- Clears `C:\Windows\Temp` folder
- Clears Windows Prefetch cache
- Runs DISM repair scan (skipped on custom OS)
- Runs System File Checker (SFC) scan

### Master_Launcher.bat - Individual Features
- **Option 3:** Garbage collection on managed memory
- **Option 4:** Hard drive file system check (read-only)
- **Option 5:** Restarts Windows Audio services
- **Option 6:** Refreshes GPU, network adapters, and USB hubs
- **Option 8:** Runs all operations sequentially
- **Option 9:** Opens the log file folder
- **Option 10:** Toggles debug mode for verbose output

## ⚠️ Important Notes
- **Admin Required:** All scripts must run with Administrator privileges
- **Backup First:** While operations are safe, consider backing up important data
- **Logging:** All operations logged to `%USERPROFILE%\Desktop\Maintenance_Logs\System_Maintenance_Log.txt`
- **Status Codes:** Check logs for error codes if an operation fails
- **Custom OS:** DISM is automatically skipped on ReviOS/AtlasOS to prevent corruption
- **Locked Files:** Errors about locked files during temp cleanup are normal and non-blocking

## 🤝 Contributing
Found a bug or have a feature request? Open an **Issue** or submit a **Pull Request**.

## 📝 Version History

### v1.5.0 (Current)
- ✅ Added Preflight_Check.bat with system validation
- ✅ Fixed variable expansion issues with delayed expansion
- ✅ Improved error handling and null checks
- ✅ Fixed PowerShell USB device restart with null validation
- ✅ Added escaped parentheses in all batch output
- ✅ Integrated preflight check into complete overhaul
- ✅ Better logging with timestamps and operation status

### v1.0.0
- Initial release with Network, System, and Audio/Hardware modules

> ⚠️ **Note:** This project was created with AI assistance and continuously improved. If you encounter issues, please report them!
