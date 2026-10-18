import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku/src/puzzle/core/puzzle_definition.dart';
import 'package:meowdoku/src/puzzle/session/puzzle_session.dart';

void main() {
  final puzzle = PuzzleDefinition(
    id: 'easy-001',
    difficulty: 'easy',
    size: 5,
    regions: List.generate(5, (row) => List.filled(5, row)),
    solutionColumns: const [0, 2, 4, 1, 3],
  );

  test('X toggles, clear is explicit, and undo restores previous marks', () {
    final start = PuzzleSession.empty(puzzle);
    final marked = SessionReducer.apply(puzzle, start, const MarkX(0, 1));
    expect(marked.session.markAt(0, 1), CellMark.x);
    expect(marked.changed, isTrue);
    final toggled = SessionReducer.apply(
      puzzle,
      marked.session,
      const MarkX(0, 1),
    );
    expect(toggled.session.markAt(0, 1), CellMark.empty);
    final restored = SessionReducer.apply(
      puzzle,
      toggled.session,
      const Undo(),
    );
    expect(restored.session.markAt(0, 1), CellMark.x);
    final cleared = SessionReducer.apply(
      puzzle,
      restored.session,
      const ClearCell(0, 1),
    );
    expect(cleared.session.markAt(0, 1), CellMark.empty);
    expect(
      SessionReducer.apply(
        puzzle,
        cleared.session,
        const ClearCell(0, 1),
      ).changed,
      isFalse,
    );
  });

  test('wrong cat is transient and does not alter marks or undo', () {
    final initial = SessionReducer.apply(
      puzzle,
      PuzzleSession.empty(puzzle),
      const MarkX(0, 1),
    ).session;
    final missed = SessionReducer.apply(puzzle, initial, const PlaceCat(0, 1));
    expect(missed.changed, isFalse);
    expect(missed.feedback, SessionFeedback.missed);
    expect(missed.session, same(initial));
    expect(missed.session.undoDepth, 1);
    final undone = SessionReducer.apply(puzzle, missed.session, const Undo());
    expect(undone.session.markAt(0, 1), CellMark.empty);
    expect(undone.session.undoDepth, 0);
  });

  test('correct cat toggles off on repeated placement', () {
    final initial = PuzzleSession.empty(puzzle);
    final placed = SessionReducer.apply(puzzle, initial, const PlaceCat(0, 0));
    expect(placed.session.markAt(0, 0), CellMark.cat);
    final toggled = SessionReducer.apply(
      puzzle,
      placed.session,
      const PlaceCat(0, 0),
    );
    expect(toggled.session.markAt(0, 0), CellMark.empty);
  });

  test('all target cats complete puzzle without any X marks', () {
    var session = PuzzleSession.empty(puzzle);
    for (var row = 0; row < puzzle.size; row++) {
      final result = SessionReducer.apply(
        puzzle,
        session,
        PlaceCat(row, puzzle.solutionColumns[row]),
      );
      session = result.session;
      expect(result.completed, row == puzzle.size - 1);
    }
    expect(session.marks.where((mark) => mark == CellMark.x), isEmpty);
  });

  test('out of bounds actions and mismatched puzzle are rejected', () {
    final session = PuzzleSession.empty(puzzle);
    expect(
      () => SessionReducer.apply(puzzle, session, const MarkX(5, 0)),
      throwsRangeError,
    );
    expect(
      () => SessionReducer.apply(
        puzzle.copyWith(id: 'easy-002'),
        session,
        const MarkX(0, 0),
      ),
      throwsArgumentError,
    );
  });
}
