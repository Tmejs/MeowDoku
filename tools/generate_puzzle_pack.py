#!/usr/bin/env python3
"""Rebuild the immutable MVP pack from a fixed seed with Python stdlib only."""

import argparse
import hashlib
import json
import random
from pathlib import Path

from deduction_rules import trace
from puzzle_rules import SIZES, canonical, connected, count_solutions, validate

SEED = 20261017
GENERATOR_VERSION = 1
MAX_ATTEMPTS_PER_DIFFICULTY = 500000
DEFAULT_OUTPUT = Path(__file__).resolve().parents[1] / "mobile/assets/puzzles/mvp-v1.json"


def solution_for(n, randomizer):
    for _ in range(1000):
        columns = list(range(n))
        randomizer.shuffle(columns)
        if all(abs(columns[row] - columns[row - 1]) > 1 for row in range(1, n)):
            return columns
    raise RuntimeError("unable to find cat placement")


def grow_regions(solution, randomizer, singleton_count=0):
    n = len(solution)
    singleton_labels = set(randomizer.sample(range(n), singleton_count))
    board = [[-1] * n for _ in range(n)]
    sizes = [1] * n
    for row, col in enumerate(solution):
        board[row][col] = row
    unassigned = n * n - n
    while unassigned:
        frontier = []
        for row in range(n):
            for col in range(n):
                if board[row][col] != -1:
                    continue
                neighbors = {board[r][c] for r, c in ((row - 1, col), (row + 1, col),
                             (row, col - 1), (row, col + 1))
                             if 0 <= r < n and 0 <= c < n and board[r][c] != -1}
                for label in neighbors:
                    if label in singleton_labels:
                        continue
                    frontier.append((row, col, label))
        if not frontier:
            raise RuntimeError("unreachable unassigned cell")
        # Vary region sizes while gently preferring smaller frontiers.
        weights = [1.0 / (sizes[label] ** randomizer.uniform(0.3, 1.8))
                   for _, _, label in frontier]
        row, col, label = randomizer.choices(frontier, weights=weights, k=1)[0]
        board[row][col] = label
        sizes[label] += 1
        unassigned -= 1
    return board


def improve_regions(board, solution, randomizer, max_steps=30):
    """Move non-cat boundary cells while preserving connected regions and the target."""
    n = len(board)
    count = count_solutions(board, limit=10000)
    for _ in range(max_steps):
        if count == 1:
            break
        moves = []
        for row in range(n):
            for col in range(n):
                if solution[row] == col:
                    continue
                destinations = {board[r][c] for r, c in
                                ((row - 1, col), (row + 1, col), (row, col - 1), (row, col + 1))
                                if 0 <= r < n and 0 <= c < n and board[r][c] != board[row][col]}
                for destination in destinations:
                    moves.append((row, col, destination))
        randomizer.shuffle(moves)
        chosen = None
        for row, col, destination in moves:
            original = board[row][col]
            board[row][col] = destination
            if connected(board, original):
                candidate_count = count_solutions(board, limit=count)
                if candidate_count < count:
                    chosen = (row, col, destination, candidate_count)
                    board[row][col] = original
                    break
            board[row][col] = original
        if chosen is None:
            break
        row, col, destination, count = chosen
        board[row][col] = destination
    return count


def build():
    randomizer = random.Random(SEED)
    puzzles = []
    seen = set()
    attempts = {}
    for difficulty, n in SIZES.items():
        accepted = 0
        attempts[difficulty] = 0
        while accepted < 25:
            attempts[difficulty] += 1
            if attempts[difficulty] % 1000 == 0:
                print(f"{difficulty}: {accepted}/25 after {attempts[difficulty]} attempts", flush=True)
            if attempts[difficulty] > MAX_ATTEMPTS_PER_DIFFICULTY:
                raise RuntimeError(f"generation exhausted for {difficulty}")
            solution = solution_for(n, randomizer)
            regions = grow_regions(solution, randomizer,
                                   singleton_count={5: 3, 6: 2, 8: 2, 10: 4}[n])
            unique = count_solutions(regions) == 1
            if not unique and n >= 8:
                unique = improve_regions(regions, solution, randomizer) == 1
            if not unique:
                continue
            deduction = trace(regions)
            if deduction is None or deduction[0] != dict(enumerate(solution)):
                continue
            if deduction[1] < {5: 0, 6: 1, 8: 1, 10: 2}[n]:
                continue
            signature = (n, canonical(regions))
            if signature in seen:
                continue
            candidate = {"id": f"{difficulty}-{accepted + 1:03}",
                         "difficulty": difficulty, "size": n,
                         "regions": regions, "solutionColumns": solution}
            errors = validate(candidate)
            if errors:
                raise RuntimeError(f"invalid generated board: {errors}")
            seen.add(signature)
            puzzles.append(candidate)
            accepted += 1
            print(f"{difficulty}: accepted {accepted}/25 after {attempts[difficulty]} attempts", flush=True)
    return {"schemaVersion": 1, "packId": "mvp-v1", "puzzles": puzzles}, attempts


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    pack, attempts = build()
    payload = (json.dumps(pack, separators=(",", ":"), ensure_ascii=True) + "\n").encode()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(payload)
    print(json.dumps({"generatorVersion": GENERATOR_VERSION, "seed": SEED, "attempts": attempts,
                      "sha256": hashlib.sha256(payload).hexdigest()}))


if __name__ == "__main__":
    main()
