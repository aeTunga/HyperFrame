import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';

import 'core/utils/platform_utils.dart';
import 'app.dart';

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
///
/// Architecture:
/// - Uses Riverpod's ProviderScope as the root widget
/// - Maintains DevicePreview wrapper for desktop simulation
/// - Uses GoRouter for declarative navigation
void main() {
  final bool enableSimulator = PlatformUtils.shouldEnableSimulation;

  if (enableSimulator) {
    // 🚀 DESKTOP DEBUG MODE: Run with DevicePreview + Riverpod
    runApp(
      ProviderScope(
        child: DevicePreview(
          enabled: true,
          builder: (context) => const MyApp(),

          // 🎯 DEFAULT DEVICE: iPhone 16 Pro Max
          // Uncomment any line below to switch devices instantly:
          defaultDevice: Devices.ios.iPhone16ProMax,

          // defaultDevice: Devices.ios.iPhone13,
          // defaultDevice: Devices.ios.iPhone13Mini,
          // defaultDevice: Devices.ios.iPhone13ProMax,
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
      ),
    );
  } else {
    // 📱 MOBILE OR RELEASE MODE: Standard Flutter App with Riverpod
    runApp(const ProviderScope(child: MyApp()));
  }
}
