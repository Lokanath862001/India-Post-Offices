@echo off
setlocal
cd /d "%~dp0"
echo [AGY-AUTO] Launching AGY Parallel Interactive Companion Agent in background...
start "AGY Interactive Auto-Response Agent" cmd /c "python agy_auto_agent.py"
echo [AGY-AUTO] Companion agent started successfully.
endlocal
