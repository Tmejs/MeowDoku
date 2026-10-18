import 'puzzle_definition.dart';

enum DeductionTechnique {
  singleRow,
  singleColumn,
  singleRegion,
  candidateInteraction,
}

/// A forced cat and the rule-based deduction that identifies it.
final class DeductionStep {
  const DeductionStep(this.row, this.column, this.technique, this.reason);
  final int row;
  final int column;
  final DeductionTechnique technique;
  final String reason;
}

/// Propagates only visible constraints. It never reads the stored solution or
/// enumerates complete solutions, and player X notes are not premises.
final class PuzzleDeduction {
  static DeductionStep? next(
    PuzzleDefinition puzzle, {
    Map<int, int> placedCats = const {},
  }) {
    final n = puzzle.size;
    for (final entry in placedCats.entries) {
      if (entry.key < 0 ||
          entry.key >= n ||
          entry.value < 0 ||
          entry.value >= n) {
        return null;
      }
      for (final other in placedCats.entries) {
        if (entry.key != other.key &&
            _conflicts(
              puzzle,
              (entry.key, entry.value),
              (other.key, other.value),
            )) {
          return null;
        }
      }
    }
    final usedColumns = placedCats.values.toSet();
    final usedRegions = {
      for (final cat in placedCats.entries) puzzle.regions[cat.key][cat.value],
    };
    final candidates = <(int, int)>{};
    for (var row = 0; row < n; row++) {
      if (placedCats.containsKey(row)) continue;
      for (var col = 0; col < n; col++) {
        final cell = (row, col);
        if (placedCats.entries.every(
          (cat) => !_conflicts(puzzle, cell, (cat.key, cat.value)),
        )) {
          candidates.add(cell);
        }
      }
    }
    var usedInteraction = false;
    while (true) {
      final units = <List<(int, int)>>[];
      for (var row = 0; row < n; row++) {
        if (placedCats.containsKey(row)) continue;
        final cells = candidates.where((cell) => cell.$1 == row).toList();
        if (cells.isEmpty) return null;
        if (cells.length == 1) {
          return DeductionStep(
            row,
            cells.single.$2,
            usedInteraction
                ? DeductionTechnique.candidateInteraction
                : DeductionTechnique.singleRow,
            usedInteraction
                ? 'Placed cats and compatibility checks against other rows, columns, and regions leave one cell in row ${row + 1}.'
                : 'Row ${row + 1} has one cell left after the placed cats exclude columns, regions, and touching cells.',
          );
        }
        units.add(cells);
      }
      for (var col = 0; col < n; col++) {
        if (usedColumns.contains(col)) continue;
        final cells = candidates.where((cell) => cell.$2 == col).toList();
        if (cells.isEmpty) return null;
        if (cells.length == 1) {
          return DeductionStep(
            cells.single.$1,
            col,
            usedInteraction
                ? DeductionTechnique.candidateInteraction
                : DeductionTechnique.singleColumn,
            usedInteraction
                ? 'Placed cats and compatibility checks against other rows, columns, and regions leave one cell in column ${col + 1}.'
                : 'Column ${col + 1} has one cell left after the placed cats exclude rows, regions, and touching cells.',
          );
        }
        units.add(cells);
      }
      for (var region = 0; region < n; region++) {
        if (usedRegions.contains(region)) continue;
        final cells = candidates
            .where((cell) => puzzle.regions[cell.$1][cell.$2] == region)
            .toList();
        if (cells.isEmpty) return null;
        if (cells.length == 1) {
          final cell = cells.single;
          return DeductionStep(
            cell.$1,
            cell.$2,
            usedInteraction
                ? DeductionTechnique.candidateInteraction
                : DeductionTechnique.singleRegion,
            usedInteraction
                ? 'Placed cats and compatibility checks against other rows, columns, and regions leave one cell in region ${region + 1}.'
                : 'Region ${region + 1} has one cell left after the placed cats exclude rows, columns, and touching cells.',
          );
        }
        units.add(cells);
      }
      var changed = false;
      for (final cell in candidates.toList()) {
        for (final unit in units) {
          if (unit.contains(cell)) continue;
          if (unit.every((other) => _conflicts(puzzle, cell, other))) {
            candidates.remove(cell);
            changed = true;
            usedInteraction = true;
            break;
          }
        }
      }
      if (!changed) return null;
    }
  }

  static bool _conflicts(PuzzleDefinition puzzle, (int, int) a, (int, int) b) =>
      a.$1 == b.$1 ||
      a.$2 == b.$2 ||
      puzzle.regions[a.$1][a.$2] == puzzle.regions[b.$1][b.$2] ||
      ((a.$1 - b.$1).abs() <= 1 && (a.$2 - b.$2).abs() <= 1);

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
