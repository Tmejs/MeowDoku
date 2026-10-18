import 'package:flutter/material.dart';

import '../localization/app_strings.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.puzzle)),
      body: const Center(child: Text(AppStrings.puzzlePlaceholder)),
    );
  }
}
