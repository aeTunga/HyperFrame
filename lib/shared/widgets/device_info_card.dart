import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:google_fonts/google_fonts.dart';

/// Device Info Card Widget
///
/// Displays information about the current device simulation:
/// - Device name (simulated or actual)
/// - Screen dimensions
/// - Pixel ratio
/// - Platform info
class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final colorScheme = Theme.of(context).colorScheme;

    final isDesktop =
        Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    final inSimulation = kDebugMode && isDesktop;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.devices, color: colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Device Information',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildInfoRow(
              'Mode',
              inSimulation ? 'HyperFrame Simulation' : 'Native',
              Icons.info_outline,
              colorScheme,
            ),

            _buildInfoRow(
              'Platform',
              _getPlatformName(),
              Icons.computer,
              colorScheme,
            ),

            _buildInfoRow(
              'Screen Size',
              '${size.width.toInt()} x ${size.height.toInt()}',
              Icons.screenshot,
              colorScheme,
            ),

            _buildInfoRow(
              'Pixel Ratio',
              pixelRatio.toStringAsFixed(2),
              Icons.aspect_ratio,
              colorScheme,
            ),

            _buildInfoRow(
              'Logical Width',
              '${size.width.toStringAsFixed(1)} dp',
              Icons.straighten,
              colorScheme,
            ),

            const SizedBox(height: 12),

            // Simulation Status Badge
            if (inSimulation)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Simulation Active - Change device in toolbar above',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  String _getPlatformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
