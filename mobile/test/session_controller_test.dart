import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku/src/puzzle/application/session_controller.dart';
import 'package:meowdoku/src/puzzle/data/app_database.dart';
import 'package:meowdoku/src/puzzle/data/progress_repository.dart';
import 'package:meowdoku/src/puzzle/data/puzzle_pack_loader.dart';
import 'package:meowdoku/src/puzzle/session/puzzle_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('controller opens, edits, and resumes through Riverpod', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = ProgressRepository(
      database,
      await PuzzlePackLoader.load(),
    );
    final container = ProviderContainer(
      overrides: [
        progressRepositoryProvider.overrideWith((ref) async => repository),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    expect(await container.read(sessionControllerProvider.future), isNull);
    final controller = container.read(sessionControllerProvider.notifier);
    await controller.openDifficulty('medium');
    final opened = await container.read(sessionControllerProvider.future);
    expect(opened?.puzzle.difficulty, 'medium');
    await controller.dispatch(const MarkX(0, 0));
    final edited = await container.read(sessionControllerProvider.future);
    expect(edited?.session.markAt(0, 0), CellMark.x);
    await controller.resumeMostRecent();
    final resumed = await container.read(sessionControllerProvider.future);
    expect(resumed?.session.markAt(0, 0), CellMark.x);
    expect(
      jsonEncode(resumed?.session.marks.map((mark) => mark.name).toList()),
      jsonEncode(edited?.session.marks.map((mark) => mark.name).toList()),
    );
  });

  test(
    'concurrent dispatches are serialized rather than losing an edit',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final repository = ProgressRepository(
        database,
        await PuzzlePackLoader.load(),
      );
      final container = ProviderContainer(
        overrides: [
          progressRepositoryProvider.overrideWith((ref) async => repository),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await database.close();
      });
      final controller = container.read(sessionControllerProvider.notifier);
      await controller.openDifficulty('easy');
      await Future.wait([
        controller.dispatch(const MarkX(0, 0)),
        controller.dispatch(const MarkX(0, 1)),
      ]);
      final active = await container.read(sessionControllerProvider.future);
      expect(active?.session.markAt(0, 0), CellMark.x);
      expect(active?.session.markAt(0, 1), CellMark.x);
    },
  );
}
