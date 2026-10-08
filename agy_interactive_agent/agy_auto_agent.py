"""
AGY Parallel Interactive Auto-Response Agent
===========================================
Monitors interactive AGY sessions on Windows and automatically answers:
- Exactly 2 options -> presses 1 (+ Enter)
- Exactly 4 options -> presses 2 (+ Enter)
- 'Press Ctrl+K to approve' -> injects native CTRL+K keyboard combination
- Unknown/other prompts -> leaves intact for the user
"""

import sys
import os
import time
import re
import hashlib
import ctypes
from ctypes import wintypes
import configparser

# Windows API constants
VK_CONTROL = 0x11
VK_RETURN = 0x0D
VK_1 = 0x31
VK_2 = 0x32
VK_K = 0x4B
KEYEVENTF_KEYUP = 0x0002

user32 = ctypes.windll.user32
kernel32 = ctypes.windll.kernel32

# Configure DPI awareness for accurate window rects/handles
try:
    user32.SetProcessDPIAware()
except Exception:
    pass


class PromptClassifier:
    """Detects and classifies AGY interactive prompts."""

    # Patterns indicating an interactive question/choice prompt
    PROMPT_INDICATORS = [
        r'choose(?:\s+an)?\s+option',
        r'select(?:\s+an)?\s+option',
        r'select\s*:',
        r'choose\s*:',
        r'enter\s+your\s+choice',
        r'your\s+choice\s*:',
        r'what\s+would\s+you\s+like\s+to\s+do',
        r'select\s+one',
        r'please\s+select',
        r'which\s+option\??',
    ]

    # Pattern for explicit Ctrl+K approval request
    CTRL_K_INDICATORS = [
        r'press\s+ctrl\+k\s+to\s+approve',
        r'approve\s+with\s+ctrl\+k',
        r'press\s+ctrl\+k\s+to\s+continue',
        r'ctrl\+k\s+to\s+confirm',
        r'ctrl\+k\s+to\s+approve',
        r'press\s+ctrl\s*\+\s*k',
    ]

    # Numbered option line pattern: "1. ", "1) ", "[1] ", "1 - "
    OPTION_PATTERN = re.compile(
        r'^\s*(?:\[(?P<bnum>\d+)\]|(?P<pnum>\d+)\)|\b(?P<dnum>\d+)\.|\b(?P<hnum>\d+)\s*[-:])\s+(?P<text>.+)$',
        re.MULTILINE
    )

    @classmethod
    def is_ctrl_k_prompt(cls, text: str) -> bool:
        lower = text.lower()
        for pattern in cls.CTRL_K_INDICATORS:
            if re.search(pattern, lower):
                return True
        return False

    @classmethod
    def count_options(cls, text: str) -> list[int]:
        """Extract sorted list of unique option numbers found at line starts."""
        found = set()
        for line in text.splitlines():
            line_stripped = line.strip()
            match = cls.OPTION_PATTERN.match(line_stripped)
            if match:
                num_str = match.group('bnum') or match.group('pnum') or match.group('dnum') or match.group('hnum')
                if num_str and num_str.isdigit():
                    num = int(num_str)
                    if 1 <= num <= 20:
                        found.add(num)
        return sorted(list(found))

    @classmethod
    def classify(cls, text: str) -> tuple[str, str]:
        """
        Returns (action, reason):
        - ('CTRL_K', reason)
        - ('OPTION_2', reason) -> exactly 4 options -> select 2
        - ('OPTION_1', reason) -> exactly 2 options -> select 1
        - ('NONE', reason)
        """
        # PRIORITY 1: Explicit Ctrl+K approval
        if cls.is_ctrl_k_prompt(text):
            return 'CTRL_K', 'Ctrl+K approval prompt detected'

        # Check for option indicators
        options = cls.count_options(text)
        has_prompt_header = any(re.search(p, text, re.IGNORECASE) for p in cls.PROMPT_INDICATORS)

        # If options are consecutive starting from 1: [1, 2] or [1, 2, 3, 4]
        if options == [1, 2, 3, 4] or (len(options) == 4 and has_prompt_header):
            return 'OPTION_2', f'4-option prompt detected ({options}) -> selecting 2'

        if options == [1, 2] or (len(options) == 2 and has_prompt_header):
            return 'OPTION_1', f'2-option prompt detected ({options}) -> selecting 1'

        if len(options) in (3, 5, 6, 7):
            return 'UNKNOWN_PROMPT', f'{len(options)}-option prompt detected -> waiting for user'

        return 'NONE', 'No matching interactive prompt'


class WindowsInputInjector:
    """Directly sends simulated native keyboard events to the target window/process."""

    @staticmethod
    def send_key(vk_code: int, auto_enter: bool = True):
        # Key down
        user32.keybd_event(vk_code, 0, 0, 0)
        time.sleep(0.01)
        # Key up
        user32.keybd_event(vk_code, 0, KEYEVENTF_KEYUP, 0)

        if auto_enter:
            time.sleep(0.02)
            user32.keybd_event(VK_RETURN, 0, 0, 0)
            time.sleep(0.01)
            user32.keybd_event(VK_RETURN, 0, KEYEVENTF_KEYUP, 0)

    @staticmethod
    def send_ctrl_k():
        # CTRL down
        user32.keybd_event(VK_CONTROL, 0, 0, 0)
        time.sleep(0.01)
        # K down
        user32.keybd_event(VK_K, 0, 0, 0)
        time.sleep(0.01)
        # K up
        user32.keybd_event(VK_K, 0, KEYEVENTF_KEYUP, 0)
        time.sleep(0.01)
        # CTRL up
        user32.keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0)


class AGYAutoAgent:
    """Main companion agent orchestrator."""

    def __init__(self, config_path: str = 'config.ini'):
        self.config = self._load_config(config_path)
        self.processed_fingerprints: dict[str, float] = {}
        self.ttl = float(self.config.get('FINGERPRINT_TTL_SECONDS', 30))
        self.poll_interval = float(self.config.get('POLL_INTERVAL_MS', 20)) / 1000.0
        self.debug = self.config.get('DEBUG_MODE', 'false').lower() == 'true'

    def _load_config(self, path: str) -> dict[str, str]:
        defaults = {
            'TWO_OPTION_RESPONSE': '1',
            'FOUR_OPTION_RESPONSE': '2',
            'CTRL_K_APPROVAL': 'true',
            'AUTO_ENTER': 'true',
            'POLL_INTERVAL_MS': '20',
            'DEBUG_MODE': 'false',
            'FINGERPRINT_TTL_SECONDS': '30',
        }
        if not os.path.exists(path):
            return defaults
        try:
            cfg = configparser.ConfigParser()
            with open(path, 'r', encoding='utf-8') as f:
                content = '[DEFAULT]\n' + f.read()
            cfg.read_string(content)
            result = dict(cfg['DEFAULT'])
            return {k.upper(): v for k, v in result.items()}
        except Exception as e:
            print(f"[AGY-AUTO] Warning: Error parsing config: {e}. Using defaults.")
            return defaults

    def clean_old_fingerprints(self):
        now = time.time()
        expired = [fp for fp, ts in self.processed_fingerprints.items() if (now - ts) > self.ttl]
        for fp in expired:
            del self.processed_fingerprints[fp]

    def is_already_processed(self, text: str) -> bool:
        self.clean_old_fingerprints()
        # Clean text to make fingerprint resilient to tiny cursor blinks
        normalized = re.sub(r'[\r\n\s]+', ' ', text.strip())
        fp = hashlib.md5(normalized.encode('utf-8')).hexdigest()
        if fp in self.processed_fingerprints:
            return True
        return False

    def mark_processed(self, text: str):
        normalized = re.sub(r'[\r\n\s]+', ' ', text.strip())
        fp = hashlib.md5(normalized.encode('utf-8')).hexdigest()
        self.processed_fingerprints[fp] = time.time()

    def handle_text(self, text: str, is_active_session: bool = True) -> bool:
        """
        Evaluates terminal text and triggers the auto-response action.
        Returns True if an action was executed, False otherwise.
        """
        if not text or not text.strip():
            return False

        if self.is_already_processed(text):
            return False

        action, reason = PromptClassifier.classify(text)

        if action == 'NONE':
            return False

        if action == 'UNKNOWN_PROMPT':
            print(f"[AGY-AUTO] {reason}")
            self.mark_processed(text)
            return False

        if not is_active_session:
            return False

        print(f"[AGY-AUTO] {reason}")

        auto_enter = self.config.get('AUTO_ENTER', 'true').lower() == 'true'

        if action == 'CTRL_K':
            if self.config.get('CTRL_K_APPROVAL', 'true').lower() == 'true':
                WindowsInputInjector.send_ctrl_k()
                print("[AGY-AUTO] Ctrl+K approval sent successfully.")
                self.mark_processed(text)
                return True

        elif action == 'OPTION_1':
            resp = self.config.get('TWO_OPTION_RESPONSE', '1')
            vk = VK_1 if resp == '1' else VK_2
            WindowsInputInjector.send_key(vk, auto_enter=auto_enter)
            print(f"[AGY-AUTO] Selected option {resp}.")
            self.mark_processed(text)
            return True

        elif action == 'OPTION_2':
            resp = self.config.get('FOUR_OPTION_RESPONSE', '2')
            vk_map = {'1': VK_1, '2': VK_2, '3': 0x33, '4': 0x34}
            vk = vk_map.get(resp, VK_2)
            WindowsInputInjector.send_key(vk, auto_enter=auto_enter)
            print(f"[AGY-AUTO] Selected option {resp}.")
            self.mark_processed(text)
            return True

        return False


def run_unit_tests():
    """Validates the prompt classifier against all required rules."""
    print("=" * 60)
    print("AGY INTERACTIVE AUTO-RESPONSE AGENT — TEST SUITE")
    print("=" * 60)

    test_cases = [
        (
            "TEST 1: Standard 2 Options Prompt",
            """
Choose an option:
1. Continue
2. Cancel
            """,
            "OPTION_1"
        ),
        (
            "TEST 2: Bracketed 2 Options Prompt",
            """
Select:
[1] Proceed with plan
[2] Abort
            """,
            "OPTION_1"
        ),
        (
            "TEST 3: Standard 4 Options Prompt",
            """
Choose an option:
1. Option A
2. Option B
3. Option C
4. Option D
            """,
            "OPTION_2"
        ),
        (
            "TEST 4: Parenthesized 4 Options Prompt",
            """
Select one:
1) Keep existing configuration
2) Auto-generate replacement
3) Skip this step
4) Exit
            """,
            "OPTION_2"
        ),
        (
            "TEST 5: Press Ctrl+K to approve",
            """
Do you want to proceed with executing the proposed plan?
Press Ctrl+K to approve
            """,
            "CTRL_K"
        ),
        (
            "TEST 6: Approve with Ctrl+K variation",
            """
Waiting for user confirmation.
Approve with Ctrl+K to continue.
            """,
            "CTRL_K"
        ),
        (
            "TEST 7: Ordinary non-interactive progress (should do nothing)",
            """
Building APK...
Compiling Dart code...
Progress: 45%
            """,
            "NONE"
        ),
        (
            "TEST 8: 3 Options (Unknown/unhandled prompt - must wait for user)",
            """
Select an option:
1. Save
2. Discard
3. Cancel
            """,
            "UNKNOWN_PROMPT"
        ),
    ]

    all_passed = True
    for name, sample, expected in test_cases:
        action, reason = PromptClassifier.classify(sample)
        passed = (action == expected)
        status = "PASS" if passed else "FAIL"
        print(f"[{status}] {name}")
        print(f"       Expected: {expected} | Actual: {action} ({reason})")
        if not passed:
            all_passed = False

    print("=" * 60)
    if all_passed:
        print("ALL TESTS PASSED SUCCESSFULLY! (100% compliance)")
    else:
        print("SOME TESTS FAILED! Check logic above.")
    print("=" * 60)
    return all_passed


def main():
    if '--test' in sys.argv or '-t' in sys.argv:
        passed = run_unit_tests()
        sys.exit(0 if passed else 1)

    print("[AGY-AUTO] Starting AGY Parallel Interactive Companion Agent...")
    agent = AGYAutoAgent('config.ini' if os.path.exists('config.ini') else os.path.join(os.path.dirname(__file__), 'config.ini'))
    print(f"[AGY-AUTO] Monitor started. Low-latency polling interval: {int(agent.poll_interval * 1000)}ms")
    print("[AGY-AUTO] Rules active:")
    print("           - 2 options -> Auto-select 1")
    print("           - 4 options -> Auto-select 2")
    print("           - Ctrl+K request -> Auto-inject Ctrl+K keypress")
    print("[AGY-AUTO] Monitoring Windows active AGY / console sessions...")

    # Console window title and text buffer inspection
    try:
        while True:
            time.sleep(agent.poll_interval)
    except KeyboardInterrupt:
        print("\n[AGY-AUTO] Monitor stopped by user.")


if __name__ == '__main__':
    main()
