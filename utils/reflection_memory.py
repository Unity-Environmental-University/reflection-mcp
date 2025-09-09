#!/usr/bin/env python3
import json
from dataclasses import dataclass, asdict
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Any


REFLECT_DIR = Path('.local_context/reflections')
REFLECT_DIR.mkdir(parents=True, exist_ok=True)


@dataclass
class MemoryEntry:
    ts: str
    kind: str  # ask|reflect|note
    prompt: str
    response: str
    meta: Dict[str, Any]


def _path(key: str) -> Path:
    return REFLECT_DIR / f"{key}.jsonl"


def load_memories(key: str, limit: int = 50) -> List[MemoryEntry]:
    p = _path(key)
    out: List[MemoryEntry] = []
    if p.exists():
        with p.open('r', encoding='utf-8') as f:
            for line in f:
                try:
                    d = json.loads(line)
                    out.append(MemoryEntry(**d))
                except Exception:
                    continue
    return out[-limit:]


def append_memory(key: str, entry: MemoryEntry, max_total: int = 50) -> None:
    p = _path(key)
    existing = load_memories(key, limit=max_total)
    existing.append(entry)
    # trim to last max_total
    trimmed = existing[-max_total:]
    with p.open('w', encoding='utf-8') as f:
        for e in trimmed:
            f.write(json.dumps(asdict(e), ensure_ascii=False) + '\n')


def summarize_memories(key: str) -> str:
    entries = load_memories(key, limit=50)
    if not entries:
        return ""
    lines = []
    for e in entries[-10:]:
        prompt = (e.prompt or '')[:120].replace('\n', ' ')
        resp = (e.response or '')[:200].replace('\n', ' ')
        lines.append("- [{}] {}: {} => {}".format(e.ts, e.kind, prompt, resp))
    return "\n".join(lines)


__all__ = [
    'MemoryEntry',
    'load_memories',
    'append_memory',
    'summarize_memories',
    'REFLECT_DIR',
]
