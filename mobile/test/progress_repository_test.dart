import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku/src/puzzle/data/app_database.dart';
import 'package:meowdoku/src/puzzle/data/progress_repository.dart';
import 'package:meowdoku/src/puzzle/data/puzzle_pack_loader.dart';
import 'package:meowdoku/src/puzzle/session/puzzle_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory directory;
  late File databaseFile;
  late DateTime now;
  late AppDatabase database;
  late ProgressRepository repository;

  Future<void> openStore() async {
    database = AppDatabase(NativeDatabase(databaseFile));
    repository = ProgressRepository(
      database,
      await PuzzlePackLoader.load(),
      now: () => now,
    );
  }

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('meowdoku-progress-');
    databaseFile = File('${directory.path}/progress.sqlite');
    now = DateTime.utc(2026, 10, 18);
    await openStore();
  });

  tearDown(() async {
    await database.close();
    await directory.delete(recursive: true);
  });

  test('edits and undo survive reopening the database', () async {
    var active = await repository.openDifficulty('easy');
    active = await repository.apply(active, const MarkX(0, 1));
    active = await repository.apply(active, const PlaceCat(0, 0));
    active = await repository.apply(active, const Undo());
    await database.close();
    await openStore();
    final resumed = await repository.openDifficulty('easy');
    expect(resumed.puzzle.id, active.puzzle.id);
    expect(resumed.session.markAt(0, 1), CellMark.x);
    expect(resumed.session.markAt(0, 0), CellMark.empty);
    expect(resumed.session.undoDepth, 1);
    final undone = await repository.apply(resumed, const Undo());
    expect(undone.session.markAt(0, 1), CellMark.empty);
  });

  test('difficulty sessions coexist and Continue picks newest edit', () async {
    var easy = await repository.openDifficulty('easy');
    now = now.add(const Duration(seconds: 1));
    var hard = await repository.openDifficulty('hard');
    hard = await repository.apply(hard, const MarkX(0, 1));
    expect((await repository.continueMostRecent())?.puzzle.id, hard.puzzle.id);
    now = now.add(const Duration(seconds: 1));
    easy = await repository.apply(easy, const MarkX(1, 0));
    expect((await repository.continueMostRecent())?.puzzle.id, easy.puzzle.id);
    expect(
      (await repository.openDifficulty('hard')).session.markAt(0, 1),
      CellMark.x,
    );
  });

  test('wrong cat attempt never writes a save', () async {
    final active = await repository.openDifficulty('easy');
    final wrongColumn =
        (active.puzzle.solutionColumns[0] + 1) % active.puzzle.size;
    final missed = await repository.apply(active, PlaceCat(0, wrongColumn));
    expect(missed.changed, isFalse);
    expect(missed.feedback, SessionFeedback.missed);
    expect(missed.session, same(active.session));
    expect((await repository.openDifficulty('easy')).session.undoDepth, 0);
  });

  test(
    'completion remains solved through replay and difficulty switch',
    () async {
      var active = await repository.openDifficulty('easy');
      final solvedId = active.puzzle.id;
      for (var row = 0; row < active.puzzle.size; row++) {
        active = await repository.apply(
          active,
          PlaceCat(row, active.puzzle.solutionColumns[row]),
        );
      }
      expect(active.completed, isTrue);
      expect(await repository.solvedCount('easy'), 1);
      expect(
        (await repository.openDifficulty('easy')).puzzle.id,
        isNot(solvedId),
      );
      final replay = await repository.replay(solvedId);
      expect(
        replay.session.marks.every((mark) => mark == CellMark.empty),
        isTrue,
      );
      await repository.openDifficulty('medium');
      await database.close();
      await openStore();
      expect(await repository.solvedCount('easy'), 1);
      expect((await repository.openDifficulty('easy')).puzzle.id, solvedId);
    },
  );

  test(
    'obsolete and corrupt sessions recover without deleting history',
    () async {
      var active = await repository.openDifficulty('easy');
      for (var row = 0; row < active.puzzle.size; row++) {
        active = await repository.apply(
          active,
          PlaceCat(row, active.puzzle.solutionColumns[row]),
        );
      }
      var next = await repository.openDifficulty('easy');
      await database.customStatement(
        'UPDATE puzzle_sessions SET pack_id = ? WHERE puzzle_id = ?',
        ['obsolete-pack', next.puzzle.id],
      );
      next = await repository.openDifficulty('easy');
      expect(
        next.session.marks.every((mark) => mark == CellMark.empty),
        isTrue,
      );
      await database.customStatement(
        'UPDATE puzzle_sessions SET cell_marks_json = ? WHERE puzzle_id = ?',
        ['bad json', next.puzzle.id],
      );
      next = await repository.openDifficulty('easy');
      expect(
        next.session.marks.every((mark) => mark == CellMark.empty),
        isTrue,
      );
      expect(await repository.solvedCount('easy'), 1);
    },
  );

  test(
    'preferences survive reopening and keep optional motion override',
    () async {
      await repository.savePreferences(
        const GamePreferences(
          lastDifficulty: 'hard',
          regionLabelsEnabled: true,
          reducedMotionOverride: false,
        ),
      );
      await database.close();
      await openStore();
      final saved = await repository.loadPreferences();
      expect(saved.lastDifficulty, 'hard');
      expect(saved.regionLabelsEnabled, isTrue);
      expect(saved.reducedMotionOverride, isFalse);
    },
  );
}
