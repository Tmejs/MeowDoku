import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'localization/app_strings.dart';
import 'routes.dart';
import 'screens/difficulty_screen.dart';
import 'screens/home_screen.dart';
import 'screens/puzzle_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: AppStrings.appName,
        theme: appTheme(),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.difficulty: (context) => const DifficultyScreen(),
          AppRoutes.puzzle: (context) => const PuzzleScreen(),
          AppRoutes.settings: (context) => const SettingsScreen(),
        },
      ),
    );
  }
}
