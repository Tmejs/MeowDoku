import 'package:flutter/services.dart';

import '../core/puzzle_pack.dart';

final class PuzzlePackLoader {
  static const assetPath = 'assets/puzzles/mvp-v1.json';

  static Future<PuzzlePack> load() async {
    final contents = await rootBundle.loadString(assetPath);
    return PuzzlePack.parse(contents);
  }
}
