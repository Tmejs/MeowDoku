import 'dart:io';

import 'package:meowdoku/src/puzzle/core/puzzle_deduction.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_pack.dart';

void main() {
  final pack = PuzzlePack.parse(
    File('assets/puzzles/mvp-v1.json').readAsStringSync(),
  );
  for (final difficulty in const ['easy', 'medium', 'hard', 'expert']) {
    final puzzles = pack.puzzles
        .where((p) => p.difficulty == difficulty)
        .toList();
    final techniques = <DeductionTechnique, int>{};
    final interactionCounts = <int>[];
    for (final puzzle in puzzles) {
      final trace = PuzzleDeduction.trace(puzzle);
      interactionCounts.add(
        trace
            .where(
              (step) =>
                  step.technique == DeductionTechnique.candidateInteraction,
            )
            .length,
      );
      for (final step in trace) {
        techniques.update(
          step.technique,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
    }
    stdout.writeln('$difficulty: $techniques');
    stdout.writeln('interaction counts: $interactionCounts');
    final sample = puzzles.first;
    stdout.writeln(sample.id);
    for (var row = 0; row < sample.size; row++) {
      stdout.writeln(
        List.generate(
          sample.size,
          (col) => col == sample.solutionColumns[row]
              ? 'C'
              : sample.regions[row][col].toString(),
        ).join(' '),
      );
    }
  }
}
