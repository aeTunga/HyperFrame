import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_router.dart';
import 'splash_controller.dart';

/// Splash Screen View
///
/// Professional minimal design with HyperFrame branding.
/// Automatically navigates to home after initialization completes.
class SplashView extends ConsumerWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final splashState = ref.watch(splashControllerProvider);

    // Debug: Log state changes
    developer.log(
      'Splash State - isLoading: ${splashState.isLoading}, hasValue: ${splashState.hasValue}, hasError: ${splashState.hasError}',
    );

    // Listen for splash completion and navigate to home
    ref.listen(splashControllerProvider, (previous, next) {
      developer.log(
        'Splash Listener - Previous isLoading: ${previous?.isLoading}, Next isLoading: ${next.isLoading}, Next hasValue: ${next.hasValue}, Next value: ${next.value}',
      );

      // Navigate when initialization completes successfully (returns true)
      if (next.hasValue && next.value == true) {
        developer.log('Initialization complete! Navigating to home...');
        // Use addPostFrameCallback to ensure navigation happens after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            developer.log('Executing navigation to ${Routes.home}');
            context.go(Routes.home);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Geometric Logo - Modern hexagon shape
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.tertiary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.bolt_rounded,
                size: 64,
                color: colorScheme.onPrimary,
              ),
            ),

            const SizedBox(height: 32),

            // App Name
            Text(
              'HyperFrame',
              style: GoogleFonts.inter(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 8),

            // Tagline
            Text(
              'Stop burning your CPU',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 48),

            // Loading Indicator
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),

            const SizedBox(height: 16),

            // Loading text
            if (splashState.isLoading)
              Text(
                'Initializing...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
