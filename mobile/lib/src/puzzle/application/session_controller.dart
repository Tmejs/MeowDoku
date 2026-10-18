import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../data/progress_repository.dart';
import '../data/puzzle_pack_loader.dart';
import '../session/puzzle_session.dart';

final progressRepositoryProvider = FutureProvider<ProgressRepository>((
  ref,
) async {
  final pack = await PuzzlePackLoader.load();
  final database = AppDatabase.onDevice();
  ref.onDispose(database.close);
  return ProgressRepository(database, pack);
});

final sessionControllerProvider =
    AsyncNotifierProvider<SessionController, ActivePuzzle?>(
      SessionController.new,
    );

final class SessionController extends AsyncNotifier<ActivePuzzle?> {
  Future<void> _pending = Future.value();

  @override
  Future<ActivePuzzle?> build() async {
    final repository = await ref.watch(progressRepositoryProvider.future);
    return repository.continueMostRecent();
  }

  Future<void> openDifficulty(String difficulty) => _enqueue(() async {
    final repository = await ref.read(progressRepositoryProvider.future);
    state = AsyncData(await repository.openDifficulty(difficulty));
  });

  Future<void> resumeMostRecent() => _enqueue(() async {
    final repository = await ref.read(progressRepositoryProvider.future);
    state = AsyncData(await repository.continueMostRecent());
  });

  Future<void> replay(String puzzleId) => _enqueue(() async {
    final repository = await ref.read(progressRepositoryProvider.future);
    state = AsyncData(await repository.replay(puzzleId));
  });

  Future<void> dispatch(SessionAction action) => _enqueue(() async {
    final active = await future;
    if (active == null) throw StateError('No active puzzle');
    final repository = await ref.read(progressRepositoryProvider.future);
    state = AsyncData(await repository.apply(active, action));
  });

  // Rapid taps must read the result of the preceding save before reducing.
  Future<void> _enqueue(Future<void> Function() operation) {
    final queued = _pending.then((_) => operation());
    _pending = queued.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return queued;
  }
}
