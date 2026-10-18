import 'puzzle_definition.dart';
import 'puzzle_solver.dart';

/// A forced cat with a proof based on the visible rules and already placed cats.
enum DeductionTechnique {
  singleRow,
  singleColumn,
  singleRegion,
  constraintProof,
}

final class DeductionStep {
  const DeductionStep(this.row, this.column, this.technique, this.reason);
  final int row;
  final int column;
  final DeductionTechnique technique;
  final String reason;
}

final class PuzzleDeduction {
  /// Ignores player X notes; only confirmed cats may be used as premises.
  static DeductionStep? next(
    PuzzleDefinition puzzle, {
    Map<int, int> placedCats = const {},
  }) {
    if (PuzzleSolver.countSolutions(
          puzzle,
          limit: 1,
          requiredCats: placedCats,
        ) ==
        0) {
      return null;
    }
    final n = puzzle.size;
    final usedColumns = placedCats.values.toSet();
    final usedRegions = {
      for (final entry in placedCats.entries)
        puzzle.regions[entry.key][entry.value],
    };
    final candidates = <(int, int)>[];
    for (var row = 0; row < n; row++) {
      if (placedCats.containsKey(row)) continue;
      for (var col = 0; col < n; col++) {
        if (usedColumns.contains(col) ||
            usedRegions.contains(puzzle.regions[row][col]) ||
            placedCats.entries.any(
              (cat) =>
                  (cat.key - row).abs() <= 1 && (cat.value - col).abs() <= 1,
            )) {
          continue;
        }
        candidates.add((row, col));
      }
    }
    for (var row = 0; row < n; row++) {
      if (placedCats.containsKey(row)) continue;
      final inRow = candidates.where((cell) => cell.$1 == row).toList();
      if (inRow.length == 1) {
        return DeductionStep(
          row,
          inRow.single.$2,
          DeductionTechnique.singleRow,
          'Row ${row + 1} has only one cell left after the placed cats exclude columns, regions, and touching cells.',
        );
      }
    }
    for (var col = 0; col < n; col++) {
      if (usedColumns.contains(col)) continue;
      final inColumn = candidates.where((cell) => cell.$2 == col).toList();
      if (inColumn.length == 1) {
        return DeductionStep(
          inColumn.single.$1,
          col,
          DeductionTechnique.singleColumn,
          'Column ${col + 1} has only one cell left after the placed cats exclude rows, regions, and touching cells.',
        );
      }
    }
    for (var region = 0; region < n; region++) {
      if (usedRegions.contains(region)) continue;
      final inRegion = candidates
          .where((cell) => puzzle.regions[cell.$1][cell.$2] == region)
          .toList();
      if (inRegion.length == 1) {
        final cell = inRegion.single;
        return DeductionStep(
          cell.$1,
          cell.$2,
          DeductionTechnique.singleRegion,
          'Region ${region + 1} has only one cell left after the placed cats exclude rows, columns, and touching cells.',
        );
      }
    }
    // Proof by contradiction: every other cell in this row leads to no valid
    // completion. This is more expensive than a visible single, but never guesses.
    for (var row = 0; row < puzzle.size; row++) {
      if (placedCats.containsKey(row)) continue;
      final possible = <int>[];
      for (var col = 0; col < puzzle.size; col++) {
        if (PuzzleSolver.countSolutions(
              puzzle,
              limit: 1,
              requiredCats: {...placedCats, row: col},
            ) >
            0) {
          possible.add(col);
        }
      }
      if (possible.length == 1) {
        return DeductionStep(
          row,
          possible.single,
          DeductionTechnique.constraintProof,
          'Every other cell in row ${row + 1} makes it impossible to satisfy all row, column, region, and no-touch rules.',
        );
      }
    }
    return null;
  }

  static List<DeductionStep> trace(PuzzleDefinition puzzle) {
    final placed = <int, int>{};
    final steps = <DeductionStep>[];
    while (placed.length < puzzle.size) {
      final step = next(puzzle, placedCats: placed);
      if (step == null) return steps;
      placed[step.row] = step.column;
      steps.add(step);
    }
    return steps;
  }
}
