# AGY Parallel Interactive Auto-Response Agent

Lightweight, parallel Windows companion agent for AGY sessions that automatically responds to predictable interactive prompts.

## Features & Decision Rules

1. **Rule A — Two Options:**
   When an interactive prompt displays exactly 2 options:
   ```text
   Choose an option:
   1. Continue
   2. Cancel
   ```
   Auto-selects `1` and submits Enter.

2. **Rule B — Four Options:**
   When an interactive prompt displays exactly 4 options:
   ```text
   Choose an option:
   1. Option A
   2. Option B
   3. Option C
   4. Option D
   ```
   Auto-selects `2` and submits Enter.

3. **Rule C — Ctrl+K Approval:**
   When AGY asks for approval:
   ```text
   Press Ctrl+K to approve
   ```
   Auto-injects native Windows `CTRL` + `K` key events immediately without typing raw text.

4. **Unknown Prompts Protection:**
   Prompts with 3, 5, 6 options, API keys, passwords, or free text are left intact for the user.

5. **Anti-Duplicate Fingerprinting:**
   Uses MD5 prompt hashing with TTL to prevent re-firing the same prompt repeatedly.

---

## Quick Start

### 1. Verification / Installation
Double-click `INSTALL.bat` or run:
```cmd
python agy_auto_agent.py --test
```

### 2. Launching the Agent
Run in parallel alongside your AGY session:
```cmd
start_agy_interactive_agent.bat
```

### 3. Stopping the Agent
```cmd
stop_agy_interactive_agent.bat
```

---

## Configuration (`config.ini`)

```ini
TWO_OPTION_RESPONSE=1
FOUR_OPTION_RESPONSE=2
CTRL_K_APPROVAL=true
AUTO_ENTER=true
POLL_INTERVAL_MS=20
DEBUG_MODE=false
```
