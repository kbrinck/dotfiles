#!/usr/bin/env python3
"""Best-effort inventory of Neovim Lua keymaps (without executing Lua)."""
import argparse
from collections import defaultdict
from pathlib import Path
import re

QUOTED = re.compile(r'''(["'])(.*?)\1''', re.S)
DESC = re.compile(r'''\bdesc\s*=\s*(["'])(.*?)\1''', re.S)
MODE = re.compile(r'''\bmode\s*=\s*(\{[^}]*\}|["'][^"']+["'])''', re.S)
CALLS = re.compile(r'\b(vim\.keymap\.set|vim\.api\.nvim_set_keymap|vim\.api\.nvim_buf_set_keymap)\s*\(')
KEYS_BLOCK = re.compile(r'\bkeys\s*=\s*\{')
FLOATERM_MAP = re.compile(
    r"""\bvim\.g\.floaterm_keymap_(new|prev|next|toggle|kill|first|last|show|hide)\s*=\s*([\"'])(.*?)\2"""
)
FLOATERM_DESCRIPTIONS = {
    'new': 'New Floaterm terminal', 'prev': 'Previous Floaterm terminal',
    'next': 'Next Floaterm terminal', 'toggle': 'Toggle Floaterm terminal',
    'kill': 'Kill Floaterm terminal', 'first': 'First Floaterm terminal',
    'last': 'Last Floaterm terminal', 'show': 'Show Floaterm terminal',
    'hide': 'Hide Floaterm terminal',
}

MODE_NAMES = {'n': 'N', 'i': 'I', 'v': 'V', 'x': 'X', 's': 'S', 'o': 'O', 'c': 'C', 't': 'T', 'l': 'L', '!': 'I/C', '': 'All'}

def balanced(text, pos, opening='{', closing='}'):
    depth, quote, escaped, comment = 0, None, False, False
    for i in range(pos, len(text)):
        c = text[i]
        if comment:
            if c == '\n': comment = False
            continue
        if quote:
            if escaped: escaped = False
            elif c == '\\': escaped = True
            elif c == quote: quote = None
            continue
        if text.startswith('--', i): comment = True; continue
        if c in "\"'": quote = c; continue
        if c == opening: depth += 1
        elif c == closing:
            depth -= 1
            if depth == 0: return text[pos:i+1], i+1
    return '', pos+1

def quoted_values(value):
    return [m.group(2) for m in QUOTED.finditer(value)]

def modes(value, default='n'):
    if not value: return (default,)
    found = quoted_values(value)
    return tuple(dict.fromkeys(found)) if found else ('?',)

def split_top(text):
    result, start, braces, parens, quote, escaped = [], 0, 0, 0, None, False
    for i, c in enumerate(text):
        if quote:
            if escaped: escaped = False
            elif c == '\\': escaped = True
            elif c == quote: quote = None
            continue
        if c in "\"'": quote = c
        elif c == '{': braces += 1
        elif c == '}': braces -= 1
        elif c == '(': parens += 1
        elif c == ')': parens -= 1
        elif c == ',' and not braces and not parens:
            result.append(text[start:i].strip()); start = i + 1
    result.append(text[start:].strip())
    return result

def infer_description(expression):
    """Conservative fallback for mappings without an explicit desc."""
    command = re.search(r'<cmd>\s*(.*?)\s*<cr>', expression, re.I | re.S)
    if command:
        value = command.group(1).strip()
    else:
        command = re.search(r'vim\.cmd\s*\(?\s*["\'](.*?)["\']', expression, re.S)
        value = command.group(1).strip() if command else ''
    if value:
        known = {
            'w': 'Save file', 'write': 'Save file', 'q': 'Quit window',
            'quit': 'Quit window', 'wq': 'Save and quit',
            'nohlsearch': 'Clear search highlighting',
            'noh': 'Clear search highlighting',
            'bnext': 'Next buffer', 'bprevious': 'Previous buffer',
            'bdelete': 'Delete buffer',
        }
        if value.lower() in known:
            return known[value.lower()]
        return value.replace(' ', ' ', 1)
    functions = {
        'vim.diagnostic.open_float': 'Show diagnostics',
        'vim.diagnostic.setloclist': 'List window diagnostics',
        'vim.diagnostic.setqflist': 'List all diagnostics',
        'vim.lsp.buf.definition': 'Go to definition',
        'vim.lsp.buf.declaration': 'Go to declaration',
        'vim.lsp.buf.references': 'Find references',
        'vim.lsp.buf.hover': 'Show hover information',
        'vim.lsp.buf.rename': 'Rename symbol',
        'vim.lsp.buf.code_action': 'Code actions',
        'vim.lsp.buf.implementation': 'Go to implementation',
        'vim.lsp.buf.type_definition': 'Go to type definition',
        'vim.lsp.buf.signature_help': 'Signature help',
    }
    for name, description in functions.items():
        if re.search(r'\b' + re.escape(name) + r'\b', expression):
            return description
    return ''

def parse(path):
    text = path.read_text(encoding='utf-8', errors='replace')
    rows = []
    for match in CALLS.finditer(text):
        call, _ = balanced(text, text.find('(', match.start()), '(', ')')
        if not call: continue
        args = split_top(call[1:-1])
        buf = match.group(1).endswith('nvim_buf_set_keymap')
        if len(args) < (3 if buf else 2): continue
        mode_arg, key_arg = (args[1], args[2]) if buf else (args[0], args[1])
        keys = quoted_values(key_arg)
        if len(keys) != 1: continue
        desc = DESC.search(call)
        for mode in modes(mode_arg, default='?'):
            rows.append((keys[0], mode, desc.group(2) if desc else infer_description(args[3] if buf and len(args) > 3 else args[2] if len(args) > 2 else '')))
    for block in KEYS_BLOCK.finditer(text):
        body, _ = balanced(text, text.find('{', block.start()))
        if not body: continue
        pos = 1
        while pos < len(body):
            start = body.find('{', pos)
            if start < 0: break
            item, end = balanced(body, start)
            if not item: break
            fields = split_top(item[1:-1])
            first = quoted_values(fields[0]) if fields else []
            if len(first) == 1:
                desc = DESC.search(item)
                mode_match = MODE.search(item)
                for mode in modes(mode_match.group(1) if mode_match else None):
                    rows.append((first[0], mode, desc.group(2) if desc else infer_description(fields[1] if len(fields) > 1 else '')))
            pos = end
    for match in FLOATERM_MAP.finditer(text):
        rows.append((match.group(3), 'n', FLOATERM_DESCRIPTIONS[match.group(1)]))
    return rows

def mode_label(mode):
    return MODE_NAMES.get(mode, mode)

def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('directory', nargs='?', type=Path, default=Path('~/.config/nvim').expanduser())
    ap.add_argument('-o', '--output', type=Path, help='Write Markdown to a file')
    ap.add_argument('--markdown', action='store_true', help='Print Markdown to stdout')
    args = ap.parse_args()
    root = args.directory.expanduser().resolve()
    if not root.is_dir(): ap.error(f'Not a directory: {root}')
    rows = [(p.relative_to(root).as_posix(), *r) for p in sorted(root.rglob('*.lua')) for r in parse(p)]
    rows.sort(key=lambda r: (r[0].lower(), r[2], r[1].lower()))
    bykey = defaultdict(int)
    for _, key, mode, _ in rows: bykey[(key, mode)] += 1
    duplicates = sorted((key, mode, n) for (key, mode), n in bykey.items() if n > 1)
    overlaps = sorted({(a, b, mode) for (a, mode) in bykey for (b, othermode) in bykey if mode == othermode and a != b and b.startswith(a)})
    groups = sorted({r[0] for r in rows}, key=str.lower)
    entries = [(src, Path(src).stem, mode_label(mode), key, desc.replace('\n', ' ')) for src, key, mode, desc in rows]
    widths = [max((len(e[i + 1]) for e in entries), default=0) for i in range(3)]
    lines = []
    for grp in groups:
        if lines:
            lines.append('')
        for src, source, mode, key, desc in entries:
            if src == grp:
                lines.append(f'{source.ljust(widths[0])}        {mode.ljust(widths[1])}        {key.ljust(widths[2])}        {desc}')
    result = '\n'.join(lines)
    if args.output or args.markdown:
        result = '```text\n' + result + '\n```\n'
        if args.output:
            args.output.expanduser().write_text(result, encoding='utf-8')
            print(f'Wrote {args.output} ({len(rows)} definitions)')
        else:
            print(result)
    else:
        print(result)
        print('\nRepeated key definitions (same mode):')
        for key, mode, n in duplicates: print(f'  {key} ({mode_label(mode)}): {n} definitions')
        if not duplicates: print('  None found.')
        print('\nPrefix overlaps (same mode):')
        for a, b, mode in overlaps: print(f'  {a} / {b} ({mode_label(mode)})')
        if not overlaps: print('  None found.')

if __name__ == '__main__': main()
