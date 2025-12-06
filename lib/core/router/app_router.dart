import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/splash/presentation/splash_view.dart';
import '../../features/home/presentation/home_view.dart';

part 'app_router.g.dart';

/// Route paths for the application
class Routes {
  static const String splash = '/';
  static const String home = '/home';
}

/// GoRouter Provider with Riverpod
///
/// Provides a single instance of GoRouter for the entire app.
/// Uses platform-adaptive page transitions for native feel.
@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Route
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const SplashView(),
        ),
      ),

      // Home Route
      GoRoute(
        path: Routes.home,
        name: 'home',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const HomeView(),
        ),
      ),
    ],
  );
}

/// Platform-Adaptive Page Transition Builder
///
/// Returns:
/// - CupertinoPage for iOS (slide transition)
/// - MaterialPage with fade for Android (Material transition)
/// - Adapts automatically based on platform
Page<dynamic> _buildPageWithTransition({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  // iOS: Use Cupertino page with native slide transition
  if (Platform.isIOS) {
    return CupertinoPage(key: state.pageKey, child: child);
  }

  // Android & Others: Use Material page with custom transition
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition for Android
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
