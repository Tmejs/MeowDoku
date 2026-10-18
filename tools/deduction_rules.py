"""Human-style candidate propagation used to select and audit puzzle boards."""


def trace(regions):
    """Return (placed columns, interaction steps, eliminations), or None if stuck."""
    n = len(regions)
    placed = {}
    interaction_steps = 0
    eliminations = 0

    def conflicts(a, b):
        return (a[0] == b[0] or a[1] == b[1] or
                regions[a[0]][a[1]] == regions[b[0]][b[1]] or
                (abs(a[0] - b[0]) <= 1 and abs(a[1] - b[1]) <= 1))

    while len(placed) < n:
        used_cols = set(placed.values())
        used_regions = {regions[row][col] for row, col in placed.items()}
        candidates = {(row, col) for row in range(n) if row not in placed
                      for col in range(n) if all(not conflicts((row, col), cat)
                                                 for cat in placed.items())}
        used_interaction = False
        while True:
            units = []
            forced = None
            for row in range(n):
                if row in placed:
                    continue
                cells = sorted(cell for cell in candidates if cell[0] == row)
                if not cells:
                    return None
                if len(cells) == 1:
                    forced = cells[0]
                    break
                units.append(cells)
            if forced is None:
                for col in range(n):
                    if col in used_cols:
                        continue
                    cells = sorted(cell for cell in candidates if cell[1] == col)
                    if not cells:
                        return None
                    if len(cells) == 1:
                        forced = cells[0]
                        break
                    units.append(cells)
            if forced is None:
                for region in range(n):
                    if region in used_regions:
                        continue
                    cells = sorted(cell for cell in candidates if regions[cell[0]][cell[1]] == region)
                    if not cells:
                        return None
                    if len(cells) == 1:
                        forced = cells[0]
                        break
                    units.append(cells)
            if forced is not None:
                placed[forced[0]] = forced[1]
                if used_interaction:
                    interaction_steps += 1
                break
            changed = False
            for cell in sorted(candidates):
                for unit in units:
                    if cell in unit:
                        continue
                    if all(conflicts(cell, other) for other in unit):
                        candidates.remove(cell)
                        eliminations += 1
                        used_interaction = True
                        changed = True
                        break
            if not changed:
                return None
    return placed, interaction_steps, eliminations
