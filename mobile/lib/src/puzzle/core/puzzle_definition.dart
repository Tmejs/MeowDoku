import 'dart:collection';

/// Presentation-free, immutable definition of one region puzzle.
final class PuzzleDefinition {
  PuzzleDefinition({
    required this.id,
    required this.difficulty,
    required this.size,
    required List<List<int>> regions,
    required List<int> solutionColumns,
  }) : regions = UnmodifiableListView(
         regions.map((row) => UnmodifiableListView(row)),
       ),
       solutionColumns = UnmodifiableListView(solutionColumns);

  final String id;
  final String difficulty;
  final int size;
  final List<List<int>> regions;
  final List<int> solutionColumns;

  PuzzleDefinition copyWith({
    String? id,
    String? difficulty,
    int? size,
    List<List<int>>? regions,
    List<int>? solutionColumns,
  }) => PuzzleDefinition(
    id: id ?? this.id,
    difficulty: difficulty ?? this.difficulty,
    size: size ?? this.size,
    regions: regions ?? this.regions,
    solutionColumns: solutionColumns ?? this.solutionColumns,
  );

  factory PuzzleDefinition.fromJson(Map<String, dynamic> json) =>
      PuzzleDefinition(
        id: json['id'] as String,
        difficulty: json['difficulty'] as String,
        size: json['size'] as int,
        regions: (json['regions'] as List)
            .map((row) => (row as List).cast<int>())
            .toList(),
        solutionColumns: (json['solutionColumns'] as List).cast<int>(),
      );
}
