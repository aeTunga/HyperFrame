import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/theme_provider.dart';

/// Device & Theme Tab
///
/// Debug tool for viewing device information and controlling theme settings.
class DeviceThemeTab extends ConsumerWidget {
  const DeviceThemeTab({super.key});

  String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  String _getOrientation(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return size.width > size.height ? 'Landscape' : 'Portrait';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            '📱 Device & Theme',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Device information and theme controls',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),

          // Device Information Section
          _SectionCard(
            title: '📱 Device Information',
            icon: Icons.phone_android,
            children: [
              _InfoRow(
                label: 'Platform',
                value: _getPlatformName(),
                icon: Icons.devices,
              ),
              _InfoRow(
                label: 'Screen Size',
                value:
                    '${mediaQuery.size.width.toInt()} × ${mediaQuery.size.height.toInt()}',
                icon: Icons.aspect_ratio,
              ),
              _InfoRow(
                label: 'Pixel Ratio',
                value: mediaQuery.devicePixelRatio.toStringAsFixed(2),
                icon: Icons.grain,
              ),
              _InfoRow(
                label: 'Text Scale',
                value: mediaQuery.textScaler.scale(1.0).toStringAsFixed(2),
                icon: Icons.text_fields,
              ),
              _InfoRow(
                label: 'Orientation',
                value: _getOrientation(context),
                icon: Icons.screen_rotation,
              ),
              _InfoRow(
                label: 'Safe Area Top',
                value: '${mediaQuery.padding.top.toInt()}px',
                icon: Icons.vertical_align_top,
              ),
              _InfoRow(
                label: 'Safe Area Bottom',
                value: '${mediaQuery.padding.bottom.toInt()}px',
                icon: Icons.vertical_align_bottom,
              ),
              _InfoRow(
                label: 'Brightness',
                value: mediaQuery.platformBrightness == Brightness.dark
                    ? 'Dark'
                    : 'Light',
                icon: Icons.brightness_medium,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Theme Settings Section
          _SectionCard(
            title: '🎨 Theme Settings',
            icon: Icons.palette,
            children: [
              const SizedBox(height: 8),

              // Theme Mode Radio Buttons
              RadioListTile<ThemeMode>(
                title: const Text('Light Mode'),
                subtitle: const Text('Always use light theme'),
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) themeNotifier.setThemeMode(value);
                },
                secondary: const Icon(Icons.light_mode),
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark Mode'),
                subtitle: const Text('Always use dark theme'),
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) themeNotifier.setThemeMode(value);
                },
                secondary: const Icon(Icons.dark_mode),
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                subtitle: const Text('Follow system theme'),
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) themeNotifier.setThemeMode(value);
                },
                secondary: const Icon(Icons.settings_brightness),
              ),

              const Divider(height: 32),

              // Current Theme Info
              _InfoRow(
                label: 'Active Theme',
                value: themeMode == ThemeMode.system
                    ? 'System (${mediaQuery.platformBrightness == Brightness.dark ? 'Dark' : 'Light'})'
                    : themeMode == ThemeMode.dark
                    ? 'Dark'
                    : 'Light',
                icon: Icons.info_outline,
              ),
              _InfoRow(
                label: 'Is Dark Mode',
                value: theme.brightness == Brightness.dark ? 'Yes' : 'No',
                icon: Icons.contrast,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Color Preview Section
          _SectionCard(
            title: '🎨 Color Preview',
            icon: Icons.color_lens,
            children: [
              const SizedBox(height: 8),
              _ColorPreview(label: 'Primary', color: theme.colorScheme.primary),
              _ColorPreview(
                label: 'Secondary',
                color: theme.colorScheme.secondary,
              ),
              _ColorPreview(label: 'Surface', color: theme.colorScheme.surface),
              _ColorPreview(label: 'Error', color: theme.colorScheme.error),
              _ColorPreview(
                label: 'Background',
                color: theme.scaffoldBackgroundColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section Card Widget
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.iconTheme.color?.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'Courier',
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Color Preview Widget
class _ColorPreview extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorPreview({required this.label, required this.color});

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor, width: 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _colorToHex(color),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Courier',
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
