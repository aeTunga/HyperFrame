import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_controller.g.dart';

/// Splash Screen Controller
///
/// Manages splash screen logic and navigation timing.
/// After 2 seconds, automatically navigates to home screen.
/// Returns true when initialization is complete.
@riverpod
class SplashController extends _$SplashController {
  @override
  Future<bool> build() async {
    // Simulate app initialization (checking auth, loading config, etc.)
    await Future.delayed(const Duration(seconds: 2));
    // Return true to signal completion
    return true;
  }
}
