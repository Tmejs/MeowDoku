// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PuzzleSessionsTable extends PuzzleSessions
    with TableInfo<$PuzzleSessionsTable, PuzzleSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuzzleSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _puzzleIdMeta = const VerificationMeta(
    'puzzleId',
  );
  @override
  late final GeneratedColumn<String> puzzleId = GeneratedColumn<String>(
    'puzzle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packIdMeta = const VerificationMeta('packId');
  @override
  late final GeneratedColumn<String> packId = GeneratedColumn<String>(
    'pack_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cellMarksJsonMeta = const VerificationMeta(
    'cellMarksJson',
  );
  @override
  late final GeneratedColumn<String> cellMarksJson = GeneratedColumn<String>(
    'cell_marks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _undoJsonMeta = const VerificationMeta(
    'undoJson',
  );
  @override
  late final GeneratedColumn<String> undoJson = GeneratedColumn<String>(
    'undo_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    puzzleId,
    difficulty,
    packId,
    cellMarksJson,
    undoJson,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'puzzle_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PuzzleSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('puzzle_id')) {
      context.handle(
        _puzzleIdMeta,
        puzzleId.isAcceptableOrUnknown(data['puzzle_id']!, _puzzleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_puzzleIdMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('pack_id')) {
      context.handle(
        _packIdMeta,
        packId.isAcceptableOrUnknown(data['pack_id']!, _packIdMeta),
      );
    } else if (isInserting) {
      context.missing(_packIdMeta);
    }
    if (data.containsKey('cell_marks_json')) {
      context.handle(
        _cellMarksJsonMeta,
        cellMarksJson.isAcceptableOrUnknown(
          data['cell_marks_json']!,
          _cellMarksJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cellMarksJsonMeta);
    }
    if (data.containsKey('undo_json')) {
      context.handle(
        _undoJsonMeta,
        undoJson.isAcceptableOrUnknown(data['undo_json']!, _undoJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_undoJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {puzzleId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {difficulty},
  ];
  @override
  PuzzleSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PuzzleSession(
      puzzleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puzzle_id'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      packId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pack_id'],
      )!,
      cellMarksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cell_marks_json'],
      )!,
      undoJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}undo_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PuzzleSessionsTable createAlias(String alias) {
    return $PuzzleSessionsTable(attachedDatabase, alias);
  }
}

class PuzzleSession extends DataClass implements Insertable<PuzzleSession> {
  final String puzzleId;
  final String difficulty;
  final String packId;
  final String cellMarksJson;
  final String undoJson;
  final int updatedAt;
  const PuzzleSession({
    required this.puzzleId,
    required this.difficulty,
    required this.packId,
    required this.cellMarksJson,
    required this.undoJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['puzzle_id'] = Variable<String>(puzzleId);
    map['difficulty'] = Variable<String>(difficulty);
    map['pack_id'] = Variable<String>(packId);
    map['cell_marks_json'] = Variable<String>(cellMarksJson);
    map['undo_json'] = Variable<String>(undoJson);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PuzzleSessionsCompanion toCompanion(bool nullToAbsent) {
    return PuzzleSessionsCompanion(
      puzzleId: Value(puzzleId),
      difficulty: Value(difficulty),
      packId: Value(packId),
      cellMarksJson: Value(cellMarksJson),
      undoJson: Value(undoJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory PuzzleSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PuzzleSession(
      puzzleId: serializer.fromJson<String>(json['puzzleId']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      packId: serializer.fromJson<String>(json['packId']),
      cellMarksJson: serializer.fromJson<String>(json['cellMarksJson']),
      undoJson: serializer.fromJson<String>(json['undoJson']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'puzzleId': serializer.toJson<String>(puzzleId),
      'difficulty': serializer.toJson<String>(difficulty),
      'packId': serializer.toJson<String>(packId),
      'cellMarksJson': serializer.toJson<String>(cellMarksJson),
      'undoJson': serializer.toJson<String>(undoJson),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  PuzzleSession copyWith({
    String? puzzleId,
    String? difficulty,
    String? packId,
    String? cellMarksJson,
    String? undoJson,
    int? updatedAt,
  }) => PuzzleSession(
    puzzleId: puzzleId ?? this.puzzleId,
    difficulty: difficulty ?? this.difficulty,
    packId: packId ?? this.packId,
    cellMarksJson: cellMarksJson ?? this.cellMarksJson,
    undoJson: undoJson ?? this.undoJson,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PuzzleSession copyWithCompanion(PuzzleSessionsCompanion data) {
    return PuzzleSession(
      puzzleId: data.puzzleId.present ? data.puzzleId.value : this.puzzleId,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      packId: data.packId.present ? data.packId.value : this.packId,
      cellMarksJson: data.cellMarksJson.present
          ? data.cellMarksJson.value
          : this.cellMarksJson,
      undoJson: data.undoJson.present ? data.undoJson.value : this.undoJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleSession(')
          ..write('puzzleId: $puzzleId, ')
          ..write('difficulty: $difficulty, ')
          ..write('packId: $packId, ')
          ..write('cellMarksJson: $cellMarksJson, ')
          ..write('undoJson: $undoJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    puzzleId,
    difficulty,
    packId,
    cellMarksJson,
    undoJson,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PuzzleSession &&
          other.puzzleId == this.puzzleId &&
          other.difficulty == this.difficulty &&
          other.packId == this.packId &&
          other.cellMarksJson == this.cellMarksJson &&
          other.undoJson == this.undoJson &&
          other.updatedAt == this.updatedAt);
}

class PuzzleSessionsCompanion extends UpdateCompanion<PuzzleSession> {
  final Value<String> puzzleId;
  final Value<String> difficulty;
  final Value<String> packId;
  final Value<String> cellMarksJson;
  final Value<String> undoJson;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const PuzzleSessionsCompanion({
    this.puzzleId = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.packId = const Value.absent(),
    this.cellMarksJson = const Value.absent(),
    this.undoJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PuzzleSessionsCompanion.insert({
    required String puzzleId,
    required String difficulty,
    required String packId,
    required String cellMarksJson,
    required String undoJson,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : puzzleId = Value(puzzleId),
       difficulty = Value(difficulty),
       packId = Value(packId),
       cellMarksJson = Value(cellMarksJson),
       undoJson = Value(undoJson),
       updatedAt = Value(updatedAt);
  static Insertable<PuzzleSession> custom({
    Expression<String>? puzzleId,
    Expression<String>? difficulty,
    Expression<String>? packId,
    Expression<String>? cellMarksJson,
    Expression<String>? undoJson,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (puzzleId != null) 'puzzle_id': puzzleId,
      if (difficulty != null) 'difficulty': difficulty,
      if (packId != null) 'pack_id': packId,
      if (cellMarksJson != null) 'cell_marks_json': cellMarksJson,
      if (undoJson != null) 'undo_json': undoJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PuzzleSessionsCompanion copyWith({
    Value<String>? puzzleId,
    Value<String>? difficulty,
    Value<String>? packId,
    Value<String>? cellMarksJson,
    Value<String>? undoJson,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return PuzzleSessionsCompanion(
      puzzleId: puzzleId ?? this.puzzleId,
      difficulty: difficulty ?? this.difficulty,
      packId: packId ?? this.packId,
      cellMarksJson: cellMarksJson ?? this.cellMarksJson,
      undoJson: undoJson ?? this.undoJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (puzzleId.present) {
      map['puzzle_id'] = Variable<String>(puzzleId.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (packId.present) {
      map['pack_id'] = Variable<String>(packId.value);
    }
    if (cellMarksJson.present) {
      map['cell_marks_json'] = Variable<String>(cellMarksJson.value);
    }
    if (undoJson.present) {
      map['undo_json'] = Variable<String>(undoJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuzzleSessionsCompanion(')
          ..write('puzzleId: $puzzleId, ')
          ..write('difficulty: $difficulty, ')
          ..write('packId: $packId, ')
          ..write('cellMarksJson: $cellMarksJson, ')
          ..write('undoJson: $undoJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletedPuzzlesTable extends CompletedPuzzles
    with TableInfo<$CompletedPuzzlesTable, CompletedPuzzle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletedPuzzlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _puzzleIdMeta = const VerificationMeta(
    'puzzleId',
  );
  @override
  late final GeneratedColumn<String> puzzleId = GeneratedColumn<String>(
    'puzzle_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [puzzleId, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completed_puzzles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletedPuzzle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('puzzle_id')) {
      context.handle(
        _puzzleIdMeta,
        puzzleId.isAcceptableOrUnknown(data['puzzle_id']!, _puzzleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_puzzleIdMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {puzzleId};
  @override
  CompletedPuzzle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletedPuzzle(
      puzzleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puzzle_id'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $CompletedPuzzlesTable createAlias(String alias) {
    return $CompletedPuzzlesTable(attachedDatabase, alias);
  }
}

class CompletedPuzzle extends DataClass implements Insertable<CompletedPuzzle> {
  final String puzzleId;
  final int completedAt;
  const CompletedPuzzle({required this.puzzleId, required this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['puzzle_id'] = Variable<String>(puzzleId);
    map['completed_at'] = Variable<int>(completedAt);
    return map;
  }

  CompletedPuzzlesCompanion toCompanion(bool nullToAbsent) {
    return CompletedPuzzlesCompanion(
      puzzleId: Value(puzzleId),
      completedAt: Value(completedAt),
    );
  }

  factory CompletedPuzzle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletedPuzzle(
      puzzleId: serializer.fromJson<String>(json['puzzleId']),
      completedAt: serializer.fromJson<int>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'puzzleId': serializer.toJson<String>(puzzleId),
      'completedAt': serializer.toJson<int>(completedAt),
    };
  }

  CompletedPuzzle copyWith({String? puzzleId, int? completedAt}) =>
      CompletedPuzzle(
        puzzleId: puzzleId ?? this.puzzleId,
        completedAt: completedAt ?? this.completedAt,
      );
  CompletedPuzzle copyWithCompanion(CompletedPuzzlesCompanion data) {
    return CompletedPuzzle(
      puzzleId: data.puzzleId.present ? data.puzzleId.value : this.puzzleId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletedPuzzle(')
          ..write('puzzleId: $puzzleId, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(puzzleId, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletedPuzzle &&
          other.puzzleId == this.puzzleId &&
          other.completedAt == this.completedAt);
}

class CompletedPuzzlesCompanion extends UpdateCompanion<CompletedPuzzle> {
  final Value<String> puzzleId;
  final Value<int> completedAt;
  final Value<int> rowid;
  const CompletedPuzzlesCompanion({
    this.puzzleId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletedPuzzlesCompanion.insert({
    required String puzzleId,
    required int completedAt,
    this.rowid = const Value.absent(),
  }) : puzzleId = Value(puzzleId),
       completedAt = Value(completedAt);
  static Insertable<CompletedPuzzle> custom({
    Expression<String>? puzzleId,
    Expression<int>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (puzzleId != null) 'puzzle_id': puzzleId,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletedPuzzlesCompanion copyWith({
    Value<String>? puzzleId,
    Value<int>? completedAt,
    Value<int>? rowid,
  }) {
    return CompletedPuzzlesCompanion(
      puzzleId: puzzleId ?? this.puzzleId,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (puzzleId.present) {
      map['puzzle_id'] = Variable<String>(puzzleId.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletedPuzzlesCompanion(')
          ..write('puzzleId: $puzzleId, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastDifficultyMeta = const VerificationMeta(
    'lastDifficulty',
  );
  @override
  late final GeneratedColumn<String> lastDifficulty = GeneratedColumn<String>(
    'last_difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionLabelsEnabledMeta =
      const VerificationMeta('regionLabelsEnabled');
  @override
  late final GeneratedColumn<bool> regionLabelsEnabled = GeneratedColumn<bool>(
    'region_labels_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("region_labels_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reducedMotionOverrideMeta =
      const VerificationMeta('reducedMotionOverride');
  @override
  late final GeneratedColumn<bool> reducedMotionOverride =
      GeneratedColumn<bool>(
        'reduced_motion_override',
        aliasedName,
        true,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reduced_motion_override" IN (0, 1))',
        ),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastDifficulty,
    regionLabelsEnabled,
    reducedMotionOverride,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_difficulty')) {
      context.handle(
        _lastDifficultyMeta,
        lastDifficulty.isAcceptableOrUnknown(
          data['last_difficulty']!,
          _lastDifficultyMeta,
        ),
      );
    }
    if (data.containsKey('region_labels_enabled')) {
      context.handle(
        _regionLabelsEnabledMeta,
        regionLabelsEnabled.isAcceptableOrUnknown(
          data['region_labels_enabled']!,
          _regionLabelsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reduced_motion_override')) {
      context.handle(
        _reducedMotionOverrideMeta,
        reducedMotionOverride.isAcceptableOrUnknown(
          data['reduced_motion_override']!,
          _reducedMotionOverrideMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastDifficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_difficulty'],
      ),
      regionLabelsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}region_labels_enabled'],
      )!,
      reducedMotionOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduced_motion_override'],
      ),
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final int id;
  final String? lastDifficulty;
  final bool regionLabelsEnabled;
  final bool? reducedMotionOverride;
  const Preference({
    required this.id,
    this.lastDifficulty,
    required this.regionLabelsEnabled,
    this.reducedMotionOverride,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastDifficulty != null) {
      map['last_difficulty'] = Variable<String>(lastDifficulty);
    }
    map['region_labels_enabled'] = Variable<bool>(regionLabelsEnabled);
    if (!nullToAbsent || reducedMotionOverride != null) {
      map['reduced_motion_override'] = Variable<bool>(reducedMotionOverride);
    }
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      lastDifficulty: lastDifficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDifficulty),
      regionLabelsEnabled: Value(regionLabelsEnabled),
      reducedMotionOverride: reducedMotionOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(reducedMotionOverride),
    );
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<int>(json['id']),
      lastDifficulty: serializer.fromJson<String?>(json['lastDifficulty']),
      regionLabelsEnabled: serializer.fromJson<bool>(
        json['regionLabelsEnabled'],
      ),
      reducedMotionOverride: serializer.fromJson<bool?>(
        json['reducedMotionOverride'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastDifficulty': serializer.toJson<String?>(lastDifficulty),
      'regionLabelsEnabled': serializer.toJson<bool>(regionLabelsEnabled),
      'reducedMotionOverride': serializer.toJson<bool?>(reducedMotionOverride),
    };
  }

  Preference copyWith({
    int? id,
    Value<String?> lastDifficulty = const Value.absent(),
    bool? regionLabelsEnabled,
    Value<bool?> reducedMotionOverride = const Value.absent(),
  }) => Preference(
    id: id ?? this.id,
    lastDifficulty: lastDifficulty.present
        ? lastDifficulty.value
        : this.lastDifficulty,
    regionLabelsEnabled: regionLabelsEnabled ?? this.regionLabelsEnabled,
    reducedMotionOverride: reducedMotionOverride.present
        ? reducedMotionOverride.value
        : this.reducedMotionOverride,
  );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      lastDifficulty: data.lastDifficulty.present
          ? data.lastDifficulty.value
          : this.lastDifficulty,
      regionLabelsEnabled: data.regionLabelsEnabled.present
          ? data.regionLabelsEnabled.value
          : this.regionLabelsEnabled,
      reducedMotionOverride: data.reducedMotionOverride.present
          ? data.reducedMotionOverride.value
          : this.reducedMotionOverride,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('lastDifficulty: $lastDifficulty, ')
          ..write('regionLabelsEnabled: $regionLabelsEnabled, ')
          ..write('reducedMotionOverride: $reducedMotionOverride')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastDifficulty,
    regionLabelsEnabled,
    reducedMotionOverride,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.lastDifficulty == this.lastDifficulty &&
          other.regionLabelsEnabled == this.regionLabelsEnabled &&
          other.reducedMotionOverride == this.reducedMotionOverride);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<int> id;
  final Value<String?> lastDifficulty;
  final Value<bool> regionLabelsEnabled;
  final Value<bool?> reducedMotionOverride;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.lastDifficulty = const Value.absent(),
    this.regionLabelsEnabled = const Value.absent(),
    this.reducedMotionOverride = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.lastDifficulty = const Value.absent(),
    this.regionLabelsEnabled = const Value.absent(),
    this.reducedMotionOverride = const Value.absent(),
  });
  static Insertable<Preference> custom({
    Expression<int>? id,
    Expression<String>? lastDifficulty,
    Expression<bool>? regionLabelsEnabled,
    Expression<bool>? reducedMotionOverride,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastDifficulty != null) 'last_difficulty': lastDifficulty,
      if (regionLabelsEnabled != null)
        'region_labels_enabled': regionLabelsEnabled,
      if (reducedMotionOverride != null)
        'reduced_motion_override': reducedMotionOverride,
    });
  }

  PreferencesCompanion copyWith({
    Value<int>? id,
    Value<String?>? lastDifficulty,
    Value<bool>? regionLabelsEnabled,
    Value<bool?>? reducedMotionOverride,
  }) {
    return PreferencesCompanion(
      id: id ?? this.id,
      lastDifficulty: lastDifficulty ?? this.lastDifficulty,
      regionLabelsEnabled: regionLabelsEnabled ?? this.regionLabelsEnabled,
      reducedMotionOverride:
          reducedMotionOverride ?? this.reducedMotionOverride,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastDifficulty.present) {
      map['last_difficulty'] = Variable<String>(lastDifficulty.value);
    }
    if (regionLabelsEnabled.present) {
      map['region_labels_enabled'] = Variable<bool>(regionLabelsEnabled.value);
    }
    if (reducedMotionOverride.present) {
      map['reduced_motion_override'] = Variable<bool>(
        reducedMotionOverride.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('lastDifficulty: $lastDifficulty, ')
          ..write('regionLabelsEnabled: $regionLabelsEnabled, ')
          ..write('reducedMotionOverride: $reducedMotionOverride')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PuzzleSessionsTable puzzleSessions = $PuzzleSessionsTable(this);
  late final $CompletedPuzzlesTable completedPuzzles = $CompletedPuzzlesTable(
    this,
  );
  late final $PreferencesTable preferences = $PreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    puzzleSessions,
    completedPuzzles,
    preferences,
  ];
}

typedef $$PuzzleSessionsTableCreateCompanionBuilder =
    PuzzleSessionsCompanion Function({
      required String puzzleId,
      required String difficulty,
      required String packId,
      required String cellMarksJson,
      required String undoJson,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$PuzzleSessionsTableUpdateCompanionBuilder =
    PuzzleSessionsCompanion Function({
      Value<String> puzzleId,
      Value<String> difficulty,
      Value<String> packId,
      Value<String> cellMarksJson,
      Value<String> undoJson,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$PuzzleSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PuzzleSessionsTable> {
  $$PuzzleSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cellMarksJson => $composableBuilder(
    column: $table.cellMarksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get undoJson => $composableBuilder(
    column: $table.undoJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PuzzleSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PuzzleSessionsTable> {
  $$PuzzleSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packId => $composableBuilder(
    column: $table.packId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cellMarksJson => $composableBuilder(
    column: $table.cellMarksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get undoJson => $composableBuilder(
    column: $table.undoJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PuzzleSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PuzzleSessionsTable> {
  $$PuzzleSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get puzzleId =>
      $composableBuilder(column: $table.puzzleId, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packId =>
      $composableBuilder(column: $table.packId, builder: (column) => column);

  GeneratedColumn<String> get cellMarksJson => $composableBuilder(
    column: $table.cellMarksJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get undoJson =>
      $composableBuilder(column: $table.undoJson, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PuzzleSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PuzzleSessionsTable,
          PuzzleSession,
          $$PuzzleSessionsTableFilterComposer,
          $$PuzzleSessionsTableOrderingComposer,
          $$PuzzleSessionsTableAnnotationComposer,
          $$PuzzleSessionsTableCreateCompanionBuilder,
          $$PuzzleSessionsTableUpdateCompanionBuilder,
          (
            PuzzleSession,
            BaseReferences<_$AppDatabase, $PuzzleSessionsTable, PuzzleSession>,
          ),
          PuzzleSession,
          PrefetchHooks Function()
        > {
  $$PuzzleSessionsTableTableManager(
    _$AppDatabase db,
    $PuzzleSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuzzleSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuzzleSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuzzleSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> puzzleId = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> packId = const Value.absent(),
                Value<String> cellMarksJson = const Value.absent(),
                Value<String> undoJson = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PuzzleSessionsCompanion(
                puzzleId: puzzleId,
                difficulty: difficulty,
                packId: packId,
                cellMarksJson: cellMarksJson,
                undoJson: undoJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String puzzleId,
                required String difficulty,
                required String packId,
                required String cellMarksJson,
                required String undoJson,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PuzzleSessionsCompanion.insert(
                puzzleId: puzzleId,
                difficulty: difficulty,
                packId: packId,
                cellMarksJson: cellMarksJson,
                undoJson: undoJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PuzzleSessionsTable, PuzzleSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $PuzzleSessionsTable,
                    PuzzleSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PuzzleSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PuzzleSessionsTable,
      PuzzleSession,
      $$PuzzleSessionsTableFilterComposer,
      $$PuzzleSessionsTableOrderingComposer,
      $$PuzzleSessionsTableAnnotationComposer,
      $$PuzzleSessionsTableCreateCompanionBuilder,
      $$PuzzleSessionsTableUpdateCompanionBuilder,
      (
        PuzzleSession,
        BaseReferences<_$AppDatabase, $PuzzleSessionsTable, PuzzleSession>,
      ),
      PuzzleSession,
      PrefetchHooks Function()
    >;
typedef $$CompletedPuzzlesTableCreateCompanionBuilder =
    CompletedPuzzlesCompanion Function({
      required String puzzleId,
      required int completedAt,
      Value<int> rowid,
    });
typedef $$CompletedPuzzlesTableUpdateCompanionBuilder =
    CompletedPuzzlesCompanion Function({
      Value<String> puzzleId,
      Value<int> completedAt,
      Value<int> rowid,
    });

class $$CompletedPuzzlesTableFilterComposer
    extends Composer<_$AppDatabase, $CompletedPuzzlesTable> {
  $$CompletedPuzzlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompletedPuzzlesTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletedPuzzlesTable> {
  $$CompletedPuzzlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get puzzleId => $composableBuilder(
    column: $table.puzzleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompletedPuzzlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletedPuzzlesTable> {
  $$CompletedPuzzlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get puzzleId =>
      $composableBuilder(column: $table.puzzleId, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CompletedPuzzlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletedPuzzlesTable,
          CompletedPuzzle,
          $$CompletedPuzzlesTableFilterComposer,
          $$CompletedPuzzlesTableOrderingComposer,
          $$CompletedPuzzlesTableAnnotationComposer,
          $$CompletedPuzzlesTableCreateCompanionBuilder,
          $$CompletedPuzzlesTableUpdateCompanionBuilder,
          (
            CompletedPuzzle,
            BaseReferences<
              _$AppDatabase,
              $CompletedPuzzlesTable,
              CompletedPuzzle
            >,
          ),
          CompletedPuzzle,
          PrefetchHooks Function()
        > {
  $$CompletedPuzzlesTableTableManager(
    _$AppDatabase db,
    $CompletedPuzzlesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletedPuzzlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletedPuzzlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletedPuzzlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> puzzleId = const Value.absent(),
                Value<int> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletedPuzzlesCompanion(
                puzzleId: puzzleId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String puzzleId,
                required int completedAt,
                Value<int> rowid = const Value.absent(),
              }) => CompletedPuzzlesCompanion.insert(
                puzzleId: puzzleId,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompletedPuzzlesTable, CompletedPuzzle>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CompletedPuzzlesTable,
                    CompletedPuzzle
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompletedPuzzlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletedPuzzlesTable,
      CompletedPuzzle,
      $$CompletedPuzzlesTableFilterComposer,
      $$CompletedPuzzlesTableOrderingComposer,
      $$CompletedPuzzlesTableAnnotationComposer,
      $$CompletedPuzzlesTableCreateCompanionBuilder,
      $$CompletedPuzzlesTableUpdateCompanionBuilder,
      (
        CompletedPuzzle,
        BaseReferences<_$AppDatabase, $CompletedPuzzlesTable, CompletedPuzzle>,
      ),
      CompletedPuzzle,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String?> lastDifficulty,
      Value<bool> regionLabelsEnabled,
      Value<bool?> reducedMotionOverride,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<String?> lastDifficulty,
      Value<bool> regionLabelsEnabled,
      Value<bool?> reducedMotionOverride,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get regionLabelsEnabled => $composableBuilder(
    column: $table.regionLabelsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reducedMotionOverride => $composableBuilder(
    column: $table.reducedMotionOverride,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get regionLabelsEnabled => $composableBuilder(
    column: $table.regionLabelsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reducedMotionOverride => $composableBuilder(
    column: $table.reducedMotionOverride,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastDifficulty => $composableBuilder(
    column: $table.lastDifficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get regionLabelsEnabled => $composableBuilder(
    column: $table.regionLabelsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reducedMotionOverride => $composableBuilder(
    column: $table.reducedMotionOverride,
    builder: (column) => column,
  );
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastDifficulty = const Value.absent(),
                Value<bool> regionLabelsEnabled = const Value.absent(),
                Value<bool?> reducedMotionOverride = const Value.absent(),
              }) => PreferencesCompanion(
                id: id,
                lastDifficulty: lastDifficulty,
                regionLabelsEnabled: regionLabelsEnabled,
                reducedMotionOverride: reducedMotionOverride,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> lastDifficulty = const Value.absent(),
                Value<bool> regionLabelsEnabled = const Value.absent(),
                Value<bool?> reducedMotionOverride = const Value.absent(),
              }) => PreferencesCompanion.insert(
                id: id,
                lastDifficulty: lastDifficulty,
                regionLabelsEnabled: regionLabelsEnabled,
                reducedMotionOverride: reducedMotionOverride,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PreferencesTable, Preference>(table),
                  BaseReferences<_$AppDatabase, $PreferencesTable, Preference>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PuzzleSessionsTableTableManager get puzzleSessions =>
      $$PuzzleSessionsTableTableManager(_db, _db.puzzleSessions);
  $$CompletedPuzzlesTableTableManager get completedPuzzles =>
      $$CompletedPuzzlesTableTableManager(_db, _db.completedPuzzles);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
