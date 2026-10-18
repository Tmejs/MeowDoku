import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: AppStrings.settings,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRoutes.difficulty),
          child: const Text(AppStrings.chooseDifficulty),
        ),
      ),
    );
  }
}
