import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'theme/theme_provider.dart';

/// HyperFrame Entry Point
///
/// Smart Runner Logic:
/// - Detects platform (macOS, Windows, Linux)
/// - In DEBUG mode on DESKTOP: Enables DevicePreview simulation
/// - In RELEASE mode or MOBILE: Runs standard Flutter app
///
/// This approach ensures:
/// ⚡️ 10x faster development on desktop (no emulator overhead)
/// 📱 Zero performance impact on production builds
/// 🔋 Saves battery by avoiding heavy virtualization
void main() {
  // Multi-Platform Desktop Detection
  final bool isDesktop =
      Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  final bool enableSimulator = kDebugMode && isDesktop;

  if (enableSimulator) {
    // 🚀 DESKTOP DEBUG MODE: Run with DevicePreview
    runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),

        // 🎯 DEFAULT DEVICE: iPhone 16 Pro Max
        // Uncomment any line below to switch devices instantly:
        defaultDevice: Devices.ios.iPhone16ProMax,

        // defaultDevice: Devices.ios.iPhone13,
        // defaultDevice: Devices.ios.iPhone13Mini,
        //d efaultDevice: Devices.ios.iPhone13ProMax,
        // defaultDevice: Devices.ios.iPhoneSE,
        // defaultDevice: Devices.ios.iPad12InchGen4,
        // defaultDevice: Devices.ios.iPadPro11Inch,
        // defaultDevice: Devices.android.samsungGalaxyS20,
        // defaultDevice: Devices.android.samsungGalaxyNote20,
        // defaultDevice: Devices.android.samsungGalaxyNote20Ultra,
        // defaultDevice: Devices.android.samsungGalaxyA50,
        // defaultDevice: Devices.android.pixel4,
        // defaultDevice: Devices.android.pixel5,
        // defaultDevice: Devices.android.pixel6,
        // defaultDevice: Devices.android.onePlus8Pro,
        isToolbarVisible: true,
        tools: const [...DevicePreview.defaultTools],
      ),
    );
  } else {
    // 📱 MOBILE OR RELEASE MODE: Standard Flutter App
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  }
}
