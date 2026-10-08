@echo off
setlocal
echo [AGY-AUTO] Stopping AGY Interactive Auto-Response Agent processes...
wmic process where "name='python.exe' and CommandLine like '%%agy_auto_agent.py%%'" call terminate >nul 2>&1
echo [AGY-AUTO] Companion agent stopped.
endlocal
