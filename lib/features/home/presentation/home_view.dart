import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../shared/widgets/device_info_card.dart';
import '../../../shared/widgets/responsive_grid.dart';
import 'home_controller.dart';
import 'widgets/home_widgets.dart';

/// Home View - Main application screen
///
/// Features:
/// - Hero section with HyperFrame branding
/// - Interactive counter with Riverpod state management
/// - Device info display
/// - Theme toggle button
/// - Responsive grid demo
class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    // Watch counter state
    final counter = ref.watch(counterProvider);

    // Watch theme state
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HyperFrame',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          // Theme Toggle Button
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            const HeroSection(),

            const SizedBox(height: 24),

            // Counter Section
            CounterSection(counter: counter),

            const SizedBox(height: 24),

            // Device Info Card
            const DeviceInfoCard(),

            const SizedBox(height: 24),

            // Responsive Grid Demo
            Text(
              'Responsive Layout Demo',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Grid adapts to device width: ${size.width.toInt()}px',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),

            // Responsive Grid
            const ResponsiveGrid(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(counterProvider.notifier).increment();
        },
        icon: const Icon(Icons.add),
        label: const Text('Test Hot Reload'),
      ),
    );
  }
}
