import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/platform_utils.dart';

/// Hero Section Widget
///
/// Displays the HyperFrame branding with gradient background
/// and feature chips.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.rocket_launch, size: 64, color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'HyperFrame',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stop burning your CPU',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FeatureChip(label: '⚡️ 10x Faster', colorScheme: colorScheme),
              FeatureChip(label: '📱 Multi-Device', colorScheme: colorScheme),
              FeatureChip(label: '🔋 Battery Saver', colorScheme: colorScheme),
            ],
          ),
        ],
      ),
    );
  }
}

/// Feature Chip Widget
///
/// Small badge displaying a feature/benefit of HyperFrame
class FeatureChip extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;

  const FeatureChip({
    super.key,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Counter Section Widget
///
/// Interactive counter demonstrating hot reload capability
class CounterSection extends StatelessWidget {
  final int counter;

  const CounterSection({super.key, required this.counter});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inSimulation = PlatformUtils.shouldEnableSimulation;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Hot Reload Speed Test',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              inSimulation
                  ? 'Running in HyperFrame Simulator'
                  : 'Running in Standard Mode',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$counter',
              style: GoogleFonts.inter(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Button presses',
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
