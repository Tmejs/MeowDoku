import 'puzzle_definition.dart';
import 'puzzle_solver.dart';

final class PuzzleValidator {
  static List<String> validate(PuzzleDefinition puzzle) {
    final errors = <String>[];
    final n = puzzle.size;
    if (n < 1 ||
        puzzle.regions.length != n ||
        puzzle.regions.any((row) => row.length != n)) {
      return ['region grid dimensions'];
    }
    if (puzzle.solutionColumns.length != n) errors.add('solution dimensions');
    final counts = List<int>.filled(n, 0);
    for (final row in puzzle.regions) {
      for (final region in row) {
        if (region < 0 || region >= n) {
          errors.add('region ID out of range');
          return errors;
        }
        counts[region]++;
      }
    }
    if (counts.contains(0)) errors.add('missing region');
    for (var region = 0; region < n; region++) {
      if (counts[region] == 0) continue;
      final seen = <(int, int)>{};
      final startRow = puzzle.regions.indexWhere((row) => row.contains(region));
      final startCol = puzzle.regions[startRow].indexOf(region);
      final pending = <(int, int)>[(startRow, startCol)];
      while (pending.isNotEmpty) {
        final (r, c) = pending.removeLast();
        if (!seen.add((r, c))) continue;
        for (final (dr, dc) in const [(-1, 0), (1, 0), (0, -1), (0, 1)]) {
          final nr = r + dr;
          final nc = c + dc;
          if (nr >= 0 &&
              nr < n &&
              nc >= 0 &&
              nc < n &&
              puzzle.regions[nr][nc] == region &&
              !seen.contains((nr, nc))) {
            pending.add((nr, nc));
          }
        }
      }
      if (seen.length != counts[region]) errors.add('disconnected region');
    }
    if (puzzle.solutionColumns.length == n) {
      final columns = <int>{};
      final regions = <int>{};
      for (var row = 0; row < n; row++) {
        final col = puzzle.solutionColumns[row];
        if (col < 0 || col >= n) {
          errors.add('solution column out of range');
          break;
        }
        columns.add(col);
        regions.add(puzzle.regions[row][col]);
        if (row > 0 && (col - puzzle.solutionColumns[row - 1]).abs() <= 1) {
          errors.add('solution cats touch');
        }
      }
      if (columns.length != n || regions.length != n) {
        errors.add('solution violates column or region rule');
      }
    }
    if (PuzzleSolver.countSolutions(puzzle) != 1) errors.add('solution count');
    return errors;
  }
}
