#!/usr/bin/env python3
"""Increments the ngen-vN cache version in sw.js."""
import re
from pathlib import Path

SW = Path(__file__).parent.parent / "sw.js"

content = SW.read_text()
m = re.search(r"ngen-v(\d+)", content)
if not m:
    print("Cache version not found in sw.js")
    raise SystemExit(1)

n = int(m.group(1)) + 1
SW.write_text(content.replace(m.group(0), f"ngen-v{n}"))
print(f"SW bumped: ngen-v{m.group(1)} → ngen-v{n}")
