#!/usr/bin/env python3
"""
Reads design.md tokens table and patches index.html CSS variables.
Commits and pushes only if something actually changed.
"""
import re, subprocess, sys
from pathlib import Path

PROJECT = Path(__file__).parent.parent
DESIGN  = PROJECT / "design.md"
HTML    = PROJECT / "index.html"

def parse_tokens(md: str) -> dict:
    tokens = {}
    for line in md.splitlines():
        # Match table rows: | --varname | value | ... |
        m = re.match(r'\|\s*(--[\w-]+|body-bg)\s*\|\s*([^|]+?)\s*\|', line)
        if m:
            tokens[m.group(1).strip()] = m.group(2).strip()
    return tokens

def apply_tokens(html: str, tokens: dict) -> str:
    for var, val in tokens.items():
        if var == "body-bg":
            # Special case: patches background:#XXXXX in html,body rule
            html = re.sub(
                r'(html,body\{[^}]*?background:)([^;]+)(;)',
                lambda m: m.group(1) + val + m.group(3),
                html
            )
        else:
            # Patch CSS custom property inside :root { }
            html = re.sub(
                rf'({re.escape(var)}:)([^;}}]+)',
                lambda m, v=val: m.group(1) + v,
                html
            )
    return html

def run(cmd, **kwargs):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True, **kwargs)

def main():
    tokens = parse_tokens(DESIGN.read_text())
    if not tokens:
        print("No tokens found in design.md")
        sys.exit(0)

    original = HTML.read_text()
    patched  = apply_tokens(original, tokens)

    if patched == original:
        print("No design changes detected.")
        sys.exit(0)

    HTML.write_text(patched)
    print(f"Applied {len(tokens)} tokens.")

    # Check JS syntax before committing
    js_blocks = re.findall(r'<script>(.*?)</script>', patched, re.DOTALL)
    Path("/tmp/ngen_validate.js").write_text("\n".join(js_blocks))
    result = run("node --check /tmp/ngen_validate.js")
    if result.returncode != 0:
        print("JS syntax error — reverting.")
        HTML.write_text(original)
        sys.exit(1)

    run("git add index.html", cwd=PROJECT)
    run('git commit -m "design: aplicar tokens de design.md"', cwd=PROJECT)
    result = run("git push origin main", cwd=PROJECT)
    if result.returncode == 0:
        print("Pushed successfully.")
    else:
        print(f"Push failed: {result.stderr}")
        sys.exit(1)

if __name__ == "__main__":
    main()
