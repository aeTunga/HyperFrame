// This is a basic Flutter widget test for HyperFrame.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:hyperframe/app.dart';
import 'package:hyperframe/theme/theme_provider.dart';

void main() {
  testWidgets('HyperFrame app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Verify that HyperFrame title appears
    expect(find.text('HyperFrame'), findsWidgets);

    // Verify the hero section text appears
    expect(find.text('Stop burning your CPU'), findsOneWidget);

    // Verify counter starts at 0
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Counter increments when button pressed', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Find and tap the increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify counter incremented to 1
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Theme toggle button works', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

    // Find theme toggle button (should show dark_mode icon initially in light mode)
    final themeButton = find.byIcon(Icons.dark_mode);
    expect(themeButton, findsOneWidget);

    // Tap the theme toggle
    await tester.tap(themeButton);
    await tester.pump();

    // After toggling, should show light_mode icon
    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
