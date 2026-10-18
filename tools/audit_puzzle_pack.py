#!/usr/bin/env python3
"""Audit a released puzzle pack without trusting stored target placements."""

import argparse
import hashlib
import json
import re
from collections import Counter
from pathlib import Path

from puzzle_rules import SIZES, canonical, validate


def audit(pack):
    errors = []
    if not isinstance(pack, dict) or set(pack) != {"schemaVersion", "packId", "puzzles"}:
        return ["pack fields"]
    if type(pack["schemaVersion"]) is not int or pack["schemaVersion"] != 1 or not isinstance(pack["packId"], str) or not re.fullmatch(r"[a-z0-9][a-z0-9-]*", pack["packId"]):
        errors.append("pack version or ID")
    puzzles = pack["puzzles"]
    if not isinstance(puzzles, list) or len(puzzles) != 100:
        return errors + ["expected exactly 100 puzzles"]
    counts = Counter()
    ids = set()
    forms = set()
    for index, puzzle in enumerate(puzzles):
        issues = validate(puzzle)
        if issues:
            errors.append(f"puzzle {index}: {', '.join(issues)}")
            continue
        counts[puzzle["difficulty"]] += 1
        if puzzle["id"] in ids:
            errors.append(f"duplicate ID {puzzle['id']}")
        ids.add(puzzle["id"])
        form = (puzzle["size"], canonical(puzzle["regions"]))
        if form in forms:
            errors.append(f"rotated/reflected/relabeled duplicate {puzzle['id']}")
        forms.add(form)
    for difficulty in SIZES:
        if counts[difficulty] != 25:
            errors.append(f"{difficulty}: expected 25, found {counts[difficulty]}")
        expected = {f"{difficulty}-{number:03}" for number in range(1, 26)}
        if ids.isdisjoint(expected) or not expected.issubset(ids):
            errors.append(f"{difficulty}: unstable or missing IDs")
    return errors


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("pack", type=Path)
    args = parser.parse_args()
    payload = args.pack.read_bytes()
    try:
        pack = json.loads(payload)
    except (ValueError, UnicodeDecodeError) as error:
        parser.exit(1, f"invalid JSON: {error}\n")
    errors = audit(pack)
    if errors:
        parser.exit(1, "\n".join(errors) + "\n")
    print(f"PASS: 100 connected unique-solution boards; sha256={hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
