// This is a basic Flutter widget test for HyperFrame.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hyperframe/app.dart';

void main() {
  testWidgets('HyperFrame app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that HyperFrame title appears on splash screen
    expect(find.text('HyperFrame'), findsOneWidget);

    // Verify the tagline appears on splash screen
    expect(find.text('Stop burning your CPU'), findsOneWidget);

    // Wait for splash screen to complete and navigate to home
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify counter starts at 0 on home screen
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Counter increments when button pressed', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for navigation to home screen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Find and tap the increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify counter incremented to 1
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Theme toggle button exists and is tappable', (
    WidgetTester tester,
  ) async {
    // Build our app
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Wait for navigation to home screen
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Find theme toggle button by tooltip
    final themeToggle = find.byTooltip('Toggle Theme');
    expect(themeToggle, findsOneWidget);

    // Verify button can be tapped without errors
    await tester.tap(themeToggle);
    await tester.pumpAndSettle();

    // Verify button still exists after tapping
    expect(themeToggle, findsOneWidget);
  });
}
