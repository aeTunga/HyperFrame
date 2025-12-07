import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/hyper_console_button.dart';

/// HyperConsole Wrapper
///
/// Main entry point for the HyperConsole developer dashboard.
/// Wraps the app and adds a floating debug button overlay.
///
/// **CRITICAL: Debug-Only**
/// - Only visible in kDebugMode
/// - Completely stripped from release builds
/// - Zero performance impact in production
///
/// **Architecture:**
/// - Wraps BEFORE DevicePreview to ensure button is inside device frame
/// - Uses Overlay system (no Navigator dependency)
/// - Button is rendered on top using Stack positioning
///
/// **Usage in app.dart:**
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) {
///     final hyperConsoleChild = HyperConsoleWrapper(child: child!);
///     return DevicePreview.appBuilder(context, hyperConsoleChild);
///   },
///   ...
/// );
/// ```
class HyperConsoleWrapper extends StatelessWidget {
  final Widget child;

  const HyperConsoleWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // CRITICAL: kDebugMode guard ensures console is stripped in release
    if (kDebugMode) {
      return Stack(
        fit: StackFit.expand,
        children: [
          child,
          // Button uses its own context (no navigatorKey needed)
          // Positioned is direct child of Stack (required)
          const HyperConsoleButton(),
        ],
      );
    }

    // In release mode, return child directly (zero overhead)
    return child;
  }
}
