import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_deduction.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_definition.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_pack.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_solver.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_validator.dart';
import 'package:meowdoku/src/puzzle/data/puzzle_pack_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final valid = PuzzleDefinition(
    id: 'easy-001',
    difficulty: 'easy',
    size: 5,
    regions: const [
      [0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [2, 2, 2, 2, 2],
      [3, 3, 3, 3, 3],
      [4, 4, 4, 4, 4],
    ],
    solutionColumns: const [0, 2, 4, 1, 3],
  );
  final unique = valid.copyWith(
    regions: const [
      [0, 0, 1, 1, 1],
      [1, 1, 1, 4, 2],
      [3, 1, 3, 4, 2],
      [3, 3, 3, 4, 4],
      [3, 3, 4, 4, 4],
    ],
  );

  test('rejects malformed dimensions and disconnected regions', () {
    expect(
      PuzzleValidator.validate(
        valid.copyWith(
          regions: const [
            [0],
          ],
        ),
      ),
      contains('region grid dimensions'),
    );
    expect(
      PuzzleValidator.validate(
        valid.copyWith(
          regions: const [
            [0, 1, 1, 1, 1],
            [1, 1, 1, 1, 1],
            [2, 2, 0, 2, 2],
            [3, 3, 3, 3, 3],
            [4, 4, 4, 4, 4],
          ],
        ),
      ),
      contains('disconnected region'),
    );
  });

  test('counts zero and multiple solutions with cap two', () {
    expect(PuzzleSolver.countSolutions(valid), 2);
    final impossible = valid.copyWith(
      regions: const [
        [0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4],
      ],
    );
    expect(
      PuzzleSolver.countSolutions(impossible, requiredCats: const {0: 0, 1: 1}),
      0,
    );
  });

  test('rejects a valid target when the board has multiple solutions', () {
    expect(PuzzleValidator.validate(valid), contains('solution count'));
  });

  test('rejects invalid target cats and region labels', () {
    expect(
      PuzzleValidator.validate(
        unique.copyWith(solutionColumns: const [0, 1, 4, 2, 3]),
      ),
      contains('solution cats touch'),
    );
    expect(
      PuzzleValidator.validate(
        unique.copyWith(
          regions: const [
            [7, 0, 1, 1, 1],
            [1, 1, 1, 4, 2],
            [3, 1, 3, 4, 2],
            [3, 3, 3, 4, 4],
            [3, 3, 4, 4, 4],
          ],
        ),
      ),
      contains('region ID out of range'),
    );
  });

  test('unique board has a complete, independently forced trace', () {
    expect(PuzzleValidator.validate(unique), isEmpty);
    final trace = PuzzleDeduction.trace(unique);
    expect(trace.length, 5);
    final placed = <int, int>{};
    for (final step in trace) {
      expect(step.reason, isNotEmpty);
      expect(step.column, unique.solutionColumns[step.row]);
      expect(
        PuzzleSolver.countSolutions(
          unique,
          requiredCats: placed,
          forbiddenCats: {(step.row, step.column)},
        ),
        0,
      );
      placed[step.row] = step.column;
    }
  });

  test('definition is deeply immutable', () {
    expect(() => unique.regions[0][0] = 4, throwsUnsupportedError);
    expect(() => unique.solutionColumns[0] = 4, throwsUnsupportedError);
    final inputRegions = [
      [0, 0],
      [1, 1],
    ];
    final inputSolution = [0, 1];
    final snapshot = PuzzleDefinition(
      id: 'easy-999',
      difficulty: 'easy',
      size: 2,
      regions: inputRegions,
      solutionColumns: inputSolution,
    );
    inputRegions[0][0] = 1;
    inputSolution[0] = 1;
    expect(snapshot.regions[0][0], 0);
    expect(snapshot.solutionColumns[0], 0);
  });

  test('pack parser rejects corrupt content', () {
    expect(() => PuzzlePack.parse('{'), throwsFormatException);
    expect(
      () => PuzzlePack.parse(
        jsonEncode({
          'schemaVersion': 1,
          'packId': 'INVALID ID',
          'puzzles': List.empty(),
        }),
      ),
      throwsFormatException,
    );
    expect(
      () => PuzzlePack.parse(
        jsonEncode({
          'schemaVersion': 1,
          'packId': 'mvp-v1',
          'puzzles': [
            {
              'id': 'easy-001',
              'difficulty': 'easy',
              'size': 5,
              'regions': [
                [0],
              ],
              'solutionColumns': [0],
            },
          ],
        }),
      ),
      throwsFormatException,
    );
  });

  test(
    'bundled pack loads and every board has a complete forced trace',
    () async {
      final pack = await PuzzlePackLoader.load();
      expect(pack.packId, 'mvp-v1');
      expect(pack.puzzles.length, 100);
      const minimumInteractions = {
        'easy': 0,
        'medium': 1,
        'hard': 1,
        'expert': 2,
      };
      for (final puzzle in pack.puzzles) {
        expect(PuzzleValidator.validate(puzzle), isEmpty, reason: puzzle.id);
        final trace = PuzzleDeduction.trace(puzzle);
        expect(trace.length, puzzle.size, reason: puzzle.id);
        expect(
          trace
              .where(
                (step) =>
                    step.technique == DeductionTechnique.candidateInteraction,
              )
              .length,
          greaterThanOrEqualTo(minimumInteractions[puzzle.difficulty]!),
          reason: puzzle.id,
        );
        for (final step in trace) {
          expect(
            step.column,
            puzzle.solutionColumns[step.row],
            reason: puzzle.id,
          );
        }
      }
    },
  );
}
