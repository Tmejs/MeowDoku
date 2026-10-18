import 'puzzle_definition.dart';

/// Exact counter. Stops at [limit] so uniqueness audits do not enumerate all boards.
final class PuzzleSolver {
  static int countSolutions(
    PuzzleDefinition puzzle, {
    int limit = 2,
    Map<int, int> requiredCats = const {},
    Set<(int, int)> forbiddenCats = const {},
  }) {
    final n = puzzle.size;
    if (n < 1 ||
        puzzle.regions.length != n ||
        puzzle.regions.any((row) => row.length != n)) {
      return 0;
    }
    var count = 0;
    void search(int row, int columns, int regions, int previousColumn) {
      if (count >= limit) return;
      if (row == n) {
        count++;
        return;
      }
      final required = requiredCats[row];
      for (var col = 0; col < n; col++) {
        if (required != null && required != col) continue;
        if (forbiddenCats.contains((row, col))) continue;
        final region = puzzle.regions[row][col];
        if (region < 0 || region >= n) continue;
        if ((columns & (1 << col)) != 0 || (regions & (1 << region)) != 0) {
          continue;
        }
        if (previousColumn >= 0 && (col - previousColumn).abs() <= 1) continue;
        search(row + 1, columns | (1 << col), regions | (1 << region), col);
        if (count >= limit) return;
      }
    }

    search(0, 0, 0, -1);
    return count;
  }
}
