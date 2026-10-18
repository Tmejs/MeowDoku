import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../routes.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.difficulty)),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.puzzle),
          child: const Text(AppStrings.openPuzzle),
        ),
      ),
    );
  }
}
