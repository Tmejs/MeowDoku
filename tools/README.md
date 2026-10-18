# Puzzle pack tooling

Run from the repository root:

```sh
python3 tools/generate_puzzle_pack.py
python3 tools/audit_puzzle_pack.py mobile/assets/puzzles/mvp-v1.json
```

Generator version 1 was run with Python 3.9.6. It uses Python's `random.Random` with seed `20261017`. It samples a cat permutation with one cat per row and column and no cats touching. Each cat seeds a connected region. It keeps 3, 2, 2, and 4 seeds as one-cell regions for 5×5, 6×6, 8×8, and 10×10 boards respectively; other regions grow across unassigned cells. For 8×8 and 10×10 candidates, it may move non-cat boundary cells to neighboring regions while preserving connectivity and the intended cat placement. A candidate is accepted only if the independent exact counter finds one solution, its normalized region grid is new under rotations, reflections, and region renaming, and its deduction trace meets the size band's minimum constraint-proof count (0, 1, 1, 2). The output order and compact JSON formatting are deterministic.

The audit checks pack fields, stable IDs, counts, dimensions, region connectivity, target placement, exact uniqueness, and symmetry duplicates. Flutter tests load the bundled asset through `PuzzlePackLoader` and replay a justified deduction trace for all 100 boards. Board size and trace technique counts are preliminary difficulty signals; human playtesting remains necessary before release.
