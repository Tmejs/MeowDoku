import 'dart:collection';

import '../core/puzzle_definition.dart';

enum CellMark { empty, x, cat }

enum SessionFeedback { missed }

sealed class SessionAction {
  const SessionAction();
}

final class MarkX extends SessionAction {
  const MarkX(this.row, this.column);
  final int row;
  final int column;
}

final class PlaceCat extends SessionAction {
  const PlaceCat(this.row, this.column);
  final int row;
  final int column;
}

final class ClearCell extends SessionAction {
  const ClearCell(this.row, this.column);
  final int row;
  final int column;
}

final class Undo extends SessionAction {
  const Undo();
}

final class PuzzleSession {
  PuzzleSession._(
    this.puzzleId,
    this.size,
    List<CellMark> marks,
    List<List<CellMark>> undoHistory,
  ) : marks = UnmodifiableListView(List<CellMark>.of(marks)),
      undoHistory = UnmodifiableListView(
        undoHistory
            .map((frame) => UnmodifiableListView(List<CellMark>.of(frame)))
            .toList(),
      );

  factory PuzzleSession.empty(PuzzleDefinition puzzle) => PuzzleSession._(
    puzzle.id,
    puzzle.size,
    List.filled(puzzle.size * puzzle.size, CellMark.empty),
    const [],
  );

  /// Validates persisted player state against the current immutable board.
  factory PuzzleSession.restore(
    PuzzleDefinition puzzle,
    List<CellMark> marks,
    List<List<CellMark>> undoHistory,
  ) {
    bool validFrame(List<CellMark> frame) =>
        frame.length == puzzle.size * puzzle.size &&
        frame.indexed.every(
          (entry) =>
              entry.$2 != CellMark.cat ||
              entry.$1 % puzzle.size ==
                  puzzle.solutionColumns[entry.$1 ~/ puzzle.size],
        );
    if (!validFrame(marks) || !undoHistory.every(validFrame)) {
      throw const FormatException('Invalid saved session marks');
    }
    return PuzzleSession._(puzzle.id, puzzle.size, marks, undoHistory);
  }

  final String puzzleId;
  final int size;
  final List<CellMark> marks;
  final List<List<CellMark>> undoHistory;

  int get undoDepth => undoHistory.length;
  CellMark markAt(int row, int column) => marks[row * size + column];
  bool get isComplete {
    var cats = 0;
    for (final mark in marks) {
      if (mark == CellMark.cat) cats++;
    }
    return cats == size;
  }
}

final class SessionResult {
  const SessionResult(this.session, {required this.changed, this.feedback});
  final PuzzleSession session;
  final bool changed;
  final SessionFeedback? feedback;
  bool get completed => session.isComplete;
}

abstract final class SessionReducer {
  static SessionResult apply(
    PuzzleDefinition puzzle,
    PuzzleSession session,
    SessionAction action,
  ) {
    if (puzzle.id != session.puzzleId || puzzle.size != session.size) {
      throw ArgumentError('Session belongs to another puzzle');
    }
    if (action is Undo) {
      if (session.undoHistory.isEmpty) {
        return SessionResult(session, changed: false);
      }
      final frames = session.undoHistory.toList();
      final marks = frames.removeLast();
      return SessionResult(
        PuzzleSession._(session.puzzleId, session.size, marks, frames),
        changed: true,
      );
    }
    final (row, column) = switch (action) {
      MarkX(:final row, :final column) => (row, column),
      PlaceCat(:final row, :final column) => (row, column),
      ClearCell(:final row, :final column) => (row, column),
      Undo() => throw StateError('Handled above'),
    };
    if (row < 0 || row >= puzzle.size || column < 0 || column >= puzzle.size) {
      throw RangeError('Cell outside puzzle');
    }
    if (action is PlaceCat && puzzle.solutionColumns[row] != column) {
      return SessionResult(
        session,
        changed: false,
        feedback: SessionFeedback.missed,
      );
    }
    final index = row * puzzle.size + column;
    final current = session.marks[index];
    final next = switch (action) {
      MarkX() => current == CellMark.x ? CellMark.empty : CellMark.x,
      PlaceCat() => current == CellMark.cat ? CellMark.empty : CellMark.cat,
      ClearCell() => CellMark.empty,
      Undo() => throw StateError('Handled above'),
    };
    if (current == next) return SessionResult(session, changed: false);
    final marks = session.marks.toList()..[index] = next;
    final history = [...session.undoHistory, session.marks];
    return SessionResult(
      PuzzleSession._(session.puzzleId, session.size, marks, history),
      changed: true,
    );
  }
}
