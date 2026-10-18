import 'dart:convert';

import 'puzzle_definition.dart';
import 'puzzle_validator.dart';

final class PuzzlePack {
  PuzzlePack._(this.packId, this.puzzles);

  final String packId;
  final List<PuzzleDefinition> puzzles;

  factory PuzzlePack.parse(String source) {
    final Object? decoded;
    try {
      decoded = jsonDecode(source);
    } on FormatException catch (error) {
      throw FormatException('Invalid puzzle JSON: $error');
    }
    if (decoded is! Map<String, dynamic> ||
        decoded.length != 3 ||
        decoded['schemaVersion'] is! int ||
        decoded['schemaVersion'] != 1 ||
        decoded['packId'] is! String ||
        !RegExp(r'^[a-z0-9][a-z0-9-]*$')
            .hasMatch(decoded['packId'] as String) ||
        decoded['puzzles'] is! List) {
      throw const FormatException('Invalid puzzle pack header');
    }
    final raw = decoded['puzzles'] as List;
    if (raw.length != 100) throw const FormatException('Expected 100 puzzles');
    final puzzles = <PuzzleDefinition>[];
    final ids = <String>{};
    final counts = {'easy': 0, 'medium': 0, 'hard': 0, 'expert': 0};
    const sizes = {'easy': 5, 'medium': 6, 'hard': 8, 'expert': 10};
    for (final entry in raw) {
      if (entry is! Map<String, dynamic> || entry.length != 5) {
        throw const FormatException('Invalid puzzle fields');
      }
      final PuzzleDefinition puzzle;
      try {
        puzzle = PuzzleDefinition.fromJson(entry);
      } on Object {
        throw const FormatException('Invalid puzzle data');
      }
      if (!ids.add(puzzle.id) ||
          puzzle.size != sizes[puzzle.difficulty] ||
          !RegExp(r'^(easy|medium|hard|expert)-[0-9]{3}$')
              .hasMatch(puzzle.id) ||
          !puzzle.id.startsWith('${puzzle.difficulty}-') ||
          PuzzleValidator.validate(puzzle).isNotEmpty) {
        throw FormatException('Invalid puzzle ${puzzle.id}');
      }
      counts[puzzle.difficulty] = counts[puzzle.difficulty]! + 1;
      puzzles.add(puzzle);
    }
    if (counts.values.any((count) => count != 25)) {
      throw const FormatException('Expected 25 puzzles per difficulty');
    }
    for (final difficulty in sizes.keys) {
      for (var number = 1; number <= 25; number++) {
        if (!ids.contains('$difficulty-${number.toString().padLeft(3, '0')}')) {
          throw const FormatException('Missing stable puzzle ID');
        }
      }
    }
    return PuzzlePack._(
      decoded['packId'] as String,
      List.unmodifiable(puzzles),
    );
  }
}
