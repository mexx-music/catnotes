#!/usr/bin/env python3
# Heuristisches Migrationstool: ersetzt prints in lib/** und test/**
# - test/**: print( -> printOnFailure(
# - lib/**: versucht, print(...) -> logd/logi/logw/loge anhand einfacher Regeln zu migrieren
# Achtung: automatisierte Änderungen; bitte Review vor Commit/Push.

import re
from pathlib import Path

ROOT = Path('.').resolve()
lib_files = list(ROOT.glob('lib/**/*.dart'))
test_files = list(ROOT.glob('test/**/*.dart'))

def ensure_import(text):
    imp = "import 'package:catnotes/core/log.dart';"
    if imp in text:
        return text, False
    # Insert after last existing import or at top
    m = list(re.finditer(r"^\s*import .*;$", text, flags=re.M))
    if m:
        last = m[-1]
        pos = last.end()
        new = text[:pos] + "\n" + imp + text[pos:]
    else:
        new = imp + "\n" + text
    return new, True

def migrate_lib_file(p: Path) -> bool:
    text = p.read_text()
    original = text

    # Collect catch blocks with exception var names and their spans
    catches = []
    for m in re.finditer(r'catch\s*\(\s*([^,\)\s]+)(?:\s*,\s*([^\)\s]+))?\s*\)\s*\{', text):
        start = m.end()-1
        ex = m.group(1)
        st = m.group(2) or 'st'
        # find matching closing brace
        i = start
        depth = 1
        while i < len(text)-1:
            i += 1
            if text[i] == '{':
                depth += 1
            elif text[i] == '}':
                depth -= 1
            if depth == 0:
                break
        end = i
        catches.append((start, end, ex, st))

    def in_catch(pos):
        for c in catches:
            if c[0] <= pos <= c[1]:
                return c
        return None

    # Replace print(...) occurrences (simple parenthesis balancing for inner expression)
    out = []
    idx = 0
    pattern = re.compile(r'print\s*\(')
    for m in pattern.finditer(text):
        start = m.start()
        # find matching closing parenthesis for this print call
        i = m.end()-1
        depth = 1
        while i < len(text)-1:
            i += 1
            ch = text[i]
            if ch == '(':
                depth += 1
            elif ch == ')':
                depth -= 1
            if depth == 0:
                break
        end = i+1
        # capture inner content
        inner = text[m.end():i].strip()
        # detect trailing semicolon
        semicolon_end = end
        if semicolon_end < len(text) and text[semicolon_end] == ';':
            semicolon_end += 1
        pos_catch = in_catch(start)
        lower_inner = inner.lower()
        # heuristics
        if any(k in lower_inner for k in ['debug', 'trace', 'build', 'render']):
            replacement = f'logd({inner});'
        elif any(k in lower_inner for k in ['saved', 'loaded', 'created', 'deleted', 'success']):
            replacement = f'logi({inner});'
        elif 'warn' in lower_inner or 'warning' in lower_inner:
            if pos_catch:
                replacement = f'logw({inner}, {pos_catch[2]}, {pos_catch[3]});'
            else:
                replacement = f'logw({inner});'
        elif pos_catch:
            # default: inside catch -> loge(...)
            replacement = f'loge({inner}, {pos_catch[2]}, {pos_catch[3]});'
        else:
            # fallback to info
            replacement = f'logi({inner});'

        out.append(text[idx:start])
        out.append(replacement)
        idx = semicolon_end
    out.append(text[idx:])
    new_text = ''.join(out)

    if new_text != original:
        # ensure import
        new_text, added = ensure_import(new_text)
        p.write_text(new_text)
        return True
    return False


def migrate_test_file(p: Path) -> bool:
    text = p.read_text()
    new = re.sub(r'\bprint\s*\(', 'printOnFailure(', text)
    if new != text:
        p.write_text(new)
        return True
    return False

changed_lib = []
changed_test = []

for f in lib_files:
    if 'generated' in str(f):
        continue
    if migrate_lib_file(f):
        changed_lib.append(str(f))

for f in test_files:
    if migrate_test_file(f):
        changed_test.append(str(f))

print("Changed lib files:", changed_lib)
print("Changed test files:", changed_test)

