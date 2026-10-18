import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meowdoku/main.dart';

void main() {
  testWidgets('home opens difficulty and puzzle', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('MeowDoku'), findsOneWidget);
    await tester.tap(find.text('Choose difficulty'));
    await tester.pumpAndSettle();

    expect(find.text('Difficulty'), findsOneWidget);
    await tester.tap(find.text('Open puzzle'));
    await tester.pumpAndSettle();

    expect(find.text('Puzzle'), findsOneWidget);
  });

  testWidgets('home opens settings', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
  });
}
