import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class PuzzleSessions extends Table {
  TextColumn get puzzleId => text()();
  TextColumn get difficulty => text()();
  TextColumn get packId => text()();
  TextColumn get cellMarksJson => text()();
  TextColumn get undoJson => text()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {puzzleId};

  @override
  List<Set<Column>> get uniqueKeys => [
    {difficulty},
  ];
}

class CompletedPuzzles extends Table {
  TextColumn get puzzleId => text()();
  IntColumn get completedAt => integer()();

  @override
  Set<Column> get primaryKey => {puzzleId};
}

class Preferences extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get lastDifficulty => text().nullable()();
  BoolColumn get regionLabelsEnabled =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get reducedMotionOverride => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [PuzzleSessions, CompletedPuzzles, Preferences])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.onDevice() =>
      AppDatabase(driftDatabase(name: 'meowdoku_progress'));

  @override
  int get schemaVersion => 1;
}
