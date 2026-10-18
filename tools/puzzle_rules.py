"""Independent Python rules used by the offline pack builder and audit."""

import re

SIZES = {"easy": 5, "medium": 6, "hard": 8, "expert": 10}


def count_solutions(regions, required=None, forbidden=None, limit=2):
    n = len(regions)
    required = required or {}
    forbidden = forbidden or set()
    count = 0

    def walk(row, used_cols, used_regions, previous):
        nonlocal count
        if count >= limit:
            return
        if row == n:
            count += 1
            return
        fixed = required.get(row)
        for col in range(n):
            if fixed is not None and fixed != col:
                continue
            if (row, col) in forbidden:
                continue
            region = regions[row][col]
            col_bit = 1 << col
            region_bit = 1 << region
            if used_cols & col_bit or used_regions & region_bit:
                continue
            if previous >= 0 and abs(col - previous) <= 1:
                continue
            walk(row + 1, used_cols | col_bit, used_regions | region_bit, col)
            if count >= limit:
                return

    walk(0, 0, 0, -1)
    return count


def connected(regions, label):
    n = len(regions)
    cells = {(r, c) for r in range(n) for c in range(n) if regions[r][c] == label}
    if not cells:
        return False
    seen = set()
    pending = [next(iter(cells))]
    while pending:
        r, c = pending.pop()
        if (r, c) in seen:
            continue
        seen.add((r, c))
        pending.extend((r + dr, c + dc) for dr, dc in ((-1, 0), (1, 0), (0, -1), (0, 1))
                       if (r + dr, c + dc) in cells and (r + dr, c + dc) not in seen)
    return seen == cells


def canonical(regions):
    n = len(regions)
    forms = []
    for mirror in (False, True):
        for rotations in range(4):
            transformed = [[0] * n for _ in range(n)]
            for row in range(n):
                for col in range(n):
                    r, c = row, n - 1 - col if mirror else col
                    for _ in range(rotations):
                        r, c = c, n - 1 - r
                    transformed[r][c] = regions[row][col]
            labels = {}
            form = []
            for row in transformed:
                for label in row:
                    if label not in labels:
                        labels[label] = len(labels)
                    form.append(labels[label])
            forms.append(tuple(form))
    return min(forms)


def validate(puzzle):
    errors = []
    if not isinstance(puzzle, dict) or set(puzzle) != {"id", "difficulty", "size", "regions", "solutionColumns"}:
        return ["puzzle fields"]
    difficulty = puzzle["difficulty"]
    size = puzzle["size"]
    if not isinstance(difficulty, str) or difficulty not in SIZES or type(size) is not int or size != SIZES[difficulty]:
        return ["difficulty/size"]
    if not isinstance(puzzle["id"], str) or not re.fullmatch(r"(easy|medium|hard|expert)-[0-9]{3}", puzzle["id"]):
        errors.append("id format")
    if isinstance(puzzle["id"], str) and not puzzle["id"].startswith(f"{difficulty}-"):
        errors.append("id/difficulty")
    regions = puzzle["regions"]
    solution = puzzle["solutionColumns"]
    if not isinstance(regions, list) or len(regions) != size or any(
        not isinstance(row, list) or len(row) != size for row in regions
    ):
        return errors + ["region dimensions"]
    if any(type(value) is not int or value < 0 or value >= size for row in regions for value in row):
        return errors + ["region labels"]
    if not isinstance(solution, list) or len(solution) != size or any(
        type(value) is not int or value < 0 or value >= size for value in solution
    ):
        return errors + ["solution dimensions"]
    if any(not connected(regions, label) for label in range(size)):
        errors.append("disconnected region")
    if len(set(solution)) != size or len({regions[r][solution[r]] for r in range(size)}) != size:
        errors.append("target row/column/region")
    if any(abs(solution[r] - solution[r - 1]) <= 1 for r in range(1, size)):
        errors.append("target cats touch")
    if count_solutions(regions) != 1:
        errors.append("solution count")
    return errors
