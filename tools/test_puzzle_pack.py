"""Regression tests for the independent pack verifier."""

import copy
import json
import unittest
from pathlib import Path

from audit_puzzle_pack import audit
from puzzle_rules import canonical, connected, count_solutions


class PuzzlePackTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        path = Path(__file__).resolve().parents[1] / "mobile/assets/puzzles/mvp-v1.json"
        cls.pack = json.loads(path.read_text())

    def test_pack_is_valid(self):
        self.assertEqual(audit(self.pack), [])

    def test_disconnected_region_is_rejected(self):
        self.assertFalse(connected([[0, 1], [1, 0]], 0))

    def test_zero_and_multiple_solutions(self):
        rows = [[r] * 5 for r in range(5)]
        self.assertEqual(count_solutions(rows), 2)
        self.assertEqual(count_solutions(rows, required={0: 0, 1: 1}), 0)

    def test_symmetry_and_region_relabeling(self):
        board = self.pack["puzzles"][0]["regions"]
        rotated = [list(row) for row in zip(*board[::-1])]
        renamed = [[(value + 1) % 5 for value in row] for row in rotated]
        self.assertEqual(canonical(board), canonical(renamed))

    def test_duplicate_board_is_rejected(self):
        bad = copy.deepcopy(self.pack)
        bad["puzzles"][1]["regions"] = bad["puzzles"][0]["regions"]
        bad["puzzles"][1]["solutionColumns"] = bad["puzzles"][0]["solutionColumns"]
        self.assertTrue(any("duplicate" in error for error in audit(bad)))

    def test_corrupted_dimensions_are_rejected(self):
        bad = copy.deepcopy(self.pack)
        bad["puzzles"][0]["regions"][0].pop()
        self.assertTrue(any("dimensions" in error for error in audit(bad)))

    def test_multiple_solution_board_is_rejected(self):
        bad = copy.deepcopy(self.pack)
        bad["puzzles"][0]["regions"] = [[row] * 5 for row in range(5)]
        self.assertTrue(any("solution count" in error for error in audit(bad)))

    def test_malformed_json_fields_are_reported(self):
        bad = copy.deepcopy(self.pack)
        bad["puzzles"][0]["difficulty"] = []
        self.assertTrue(any("difficulty/size" in error for error in audit(bad)))


if __name__ == "__main__":
    unittest.main()
