"""
Terminal Output & Window Monitor for AGY Companion Agent
Attaches to console windows or monitors Windows terminal buffers.
"""

import sys
import os
import time
import ctypes
from ctypes import wintypes
import winreg

user32 = ctypes.windll.user32
kernel32 = ctypes.windll.kernel32

WNDENUMPROC = ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)


def get_window_text(hwnd: int) -> str:
    length = user32.GetWindowTextLengthW(hwnd)
    if length > 0:
        buff = ctypes.create_unicode_buffer(length + 1)
        user32.GetWindowTextW(hwnd, buff, length + 1)
        return buff.value
    return ""


def find_agy_windows() -> list[tuple[int, str]]:
    """Enumerate visible windows and identify AGY or interactive terminal sessions."""
    results = []

    def enum_proc(hwnd, lparam):
        if user32.IsWindowVisible(hwnd):
            title = get_window_text(hwnd)
            if title:
                lower = title.lower()
                # Matches AGY CLI, Antigravity, PowerShell, Windows Terminal running AGY
                if any(k in lower for k in ['agy', 'antigravity']):
                    results.append((hwnd, title))
        return True

    cb = WNDENUMPROC(enum_proc)
    user32.EnumWindows(cb, 0)
    return results


def is_agy_window_foreground(target_hwnd: int) -> bool:
    fg = user32.GetForegroundWindow()
    return fg == target_hwnd
