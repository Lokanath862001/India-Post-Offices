@echo off
setlocal
cd /d "%~dp0"
echo ========================================================
echo Installing AGY Parallel Interactive Auto-Response Agent
echo ========================================================
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not found in PATH. Please install Python 3.8+ on Windows.
    pause
    exit /b 1
)
echo [OK] Python is available.
echo [OK] Running self-test suite...
python agy_auto_agent.py --test
if %errorlevel% neq 0 (
    echo [ERROR] Self-test failed.
    pause
    exit /b 1
)
echo ========================================================
echo Installation and verification complete!
echo To run in parallel, execute: start_agy_interactive_agent.bat
echo ========================================================
endlocal
