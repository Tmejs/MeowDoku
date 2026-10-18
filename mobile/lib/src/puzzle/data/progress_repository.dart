import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/puzzle_definition.dart';
import '../core/puzzle_pack.dart';
import '../session/puzzle_session.dart';
import 'app_database.dart' hide PuzzleSession;

final class GamePreferences {
  const GamePreferences({
    this.lastDifficulty,
    this.regionLabelsEnabled = false,
    this.reducedMotionOverride,
  });

  final String? lastDifficulty;
  final bool regionLabelsEnabled;
  final bool? reducedMotionOverride;
}

final class ActivePuzzle {
  const ActivePuzzle(
    this.puzzle,
    this.session, {
    this.changed = false,
    this.feedback,
  });

  final PuzzleDefinition puzzle;
  final PuzzleSession session;
  final bool changed;
  final SessionFeedback? feedback;
  bool get completed => session.isComplete;
}

/// The only writer of durable player progress. Puzzle definitions stay in the asset.
final class ProgressRepository {
  ProgressRepository(this.database, this.pack, {DateTime Function()? now})
    : now = now ?? DateTime.now;

  final AppDatabase database;
  final PuzzlePack pack;
  final DateTime Function() now;

  PuzzleDefinition _puzzle(String id) => pack.puzzles.firstWhere(
    (puzzle) => puzzle.id == id,
    orElse: () => throw ArgumentError.value(id, 'puzzleId'),
  );

  Future<ActivePuzzle> openDifficulty(String difficulty) async {
    final puzzles = pack.puzzles
        .where((puzzle) => puzzle.difficulty == difficulty)
        .toList();
    if (puzzles.isEmpty) throw ArgumentError.value(difficulty, 'difficulty');
    final rows = await database
        .customSelect(
          'SELECT * FROM puzzle_sessions WHERE difficulty = ? '
          'ORDER BY updated_at DESC',
          variables: [Variable.withString(difficulty)],
        )
        .get();
    for (final row in rows) {
      final restored = _restore(row.data);
      if (restored != null) {
        await _rememberDifficulty(difficulty);
        return restored;
      }
      await _deleteSession(row.read<String>('puzzle_id'));
    }
    final solved = await _solvedIds();
    final puzzle = puzzles.firstWhere(
      (candidate) => !solved.contains(candidate.id),
      orElse: () => puzzles.first,
    );
    final active = ActivePuzzle(puzzle, PuzzleSession.empty(puzzle));
    await _save(active);
    await _rememberDifficulty(difficulty);
    return active;
  }

  Future<ActivePuzzle?> continueMostRecent() async {
    final rows = await database
        .customSelect(
          'SELECT * FROM puzzle_sessions ORDER BY updated_at DESC, puzzle_id ASC',
        )
        .get();
    for (final row in rows) {
      final restored = _restore(row.data);
      if (restored != null) return restored;
      await _deleteSession(row.read<String>('puzzle_id'));
    }
    return null;
  }

  Future<ActivePuzzle> replay(String puzzleId) async {
    final puzzle = _puzzle(puzzleId);
    final active = ActivePuzzle(puzzle, PuzzleSession.empty(puzzle));
    await _save(active);
    await _rememberDifficulty(puzzle.difficulty);
    return active;
  }

  Future<GamePreferences> loadPreferences() async {
    final rows = await database
        .customSelect('SELECT * FROM preferences WHERE id = 1')
        .get();
    if (rows.isEmpty) return const GamePreferences();
    final row = rows.single;
    return GamePreferences(
      lastDifficulty: row.readNullable<String>('last_difficulty'),
      regionLabelsEnabled: row.read<int>('region_labels_enabled') != 0,
      reducedMotionOverride: row
          .readNullable<int>('reduced_motion_override')
          ?.isOdd,
    );
  }

  Future<void> savePreferences(GamePreferences preferences) async {
    final difficulty = preferences.lastDifficulty;
    if (difficulty != null &&
        !pack.puzzles.any((puzzle) => puzzle.difficulty == difficulty)) {
      throw ArgumentError.value(difficulty, 'lastDifficulty');
    }
    await database.customStatement(
      'INSERT OR REPLACE INTO preferences '
      '(id, last_difficulty, region_labels_enabled, reduced_motion_override) '
      'VALUES (1, ?, ?, ?)',
      [
        difficulty,
        preferences.regionLabelsEnabled ? 1 : 0,
        switch (preferences.reducedMotionOverride) {
          true => 1,
          false => 0,
          null => null,
        },
      ],
    );
  }

  Future<void> _rememberDifficulty(String difficulty) async {
    final current = await loadPreferences();
    await savePreferences(
      GamePreferences(
        lastDifficulty: difficulty,
        regionLabelsEnabled: current.regionLabelsEnabled,
        reducedMotionOverride: current.reducedMotionOverride,
      ),
    );
  }

  Future<ActivePuzzle> apply(ActivePuzzle active, SessionAction action) async {
    final result = SessionReducer.apply(active.puzzle, active.session, action);
    final updated = ActivePuzzle(
      active.puzzle,
      result.session,
      changed: result.changed,
      feedback: result.feedback,
    );
    if (!result.changed) return updated;
    if (result.completed) {
      await database.transaction(() async {
        await _deleteSession(active.puzzle.id);
        await database.customStatement(
          'INSERT OR IGNORE INTO completed_puzzles (puzzle_id, completed_at) '
          'VALUES (?, ?)',
          [active.puzzle.id, now().millisecondsSinceEpoch],
        );
      });
    } else {
      await _save(updated);
    }
    return updated;
  }

  Future<int> solvedCount(String difficulty) async {
    if (!pack.puzzles.any((puzzle) => puzzle.difficulty == difficulty)) {
      throw ArgumentError.value(difficulty, 'difficulty');
    }
    final ids = await _solvedIds();
    return pack.puzzles
        .where(
          (puzzle) =>
              puzzle.difficulty == difficulty && ids.contains(puzzle.id),
        )
        .length;
  }

  Future<Set<String>> _solvedIds() async {
    final rows = await database
        .customSelect('SELECT puzzle_id FROM completed_puzzles')
        .get();
    return {for (final row in rows) row.read<String>('puzzle_id')};
  }

  Future<void> _save(ActivePuzzle active) async {
    await database.transaction(() async {
      await database.customStatement(
        'DELETE FROM puzzle_sessions WHERE difficulty = ?',
        [active.puzzle.difficulty],
      );
      await database.customStatement(
        'INSERT INTO puzzle_sessions '
        '(puzzle_id, difficulty, pack_id, cell_marks_json, undo_json, updated_at) '
        'VALUES (?, ?, ?, ?, ?, ?)',
        [
          active.puzzle.id,
          active.puzzle.difficulty,
          pack.packId,
          jsonEncode(active.session.marks.map((mark) => mark.name).toList()),
          jsonEncode(
            active.session.undoHistory
                .map((frame) => frame.map((mark) => mark.name).toList())
                .toList(),
          ),
          now().millisecondsSinceEpoch,
        ],
      );
    });
  }

  Future<void> _deleteSession(String id) => database.customStatement(
    'DELETE FROM puzzle_sessions WHERE puzzle_id = ?',
    [id],
  );

  ActivePuzzle? _restore(Map<String, dynamic> data) {
    try {
      if (data['pack_id'] != pack.packId) return null;
      final puzzle = _puzzle(data['puzzle_id'] as String);
      if (puzzle.difficulty != data['difficulty']) return null;
      final marks = _parseMarks(jsonDecode(data['cell_marks_json'] as String));
      final undoRaw = jsonDecode(data['undo_json'] as String);
      if (undoRaw is! List || undoRaw.length > 10000) return null;
      final history = undoRaw.map(_parseMarks).toList();
      final session = PuzzleSession.restore(puzzle, marks, history);
      if (session.isComplete) return null;
      return ActivePuzzle(puzzle, session);
    } on Object {
      return null;
    }
  }

  List<CellMark> _parseMarks(Object? value) {
    if (value is! List) throw const FormatException('Invalid marks');
    return value.map((item) {
      if (item is! String) throw const FormatException('Invalid mark');
      return CellMark.values.firstWhere(
        (mark) => mark.name == item,
        orElse: () => throw const FormatException('Invalid mark'),
      );
    }).toList();
  }
}
