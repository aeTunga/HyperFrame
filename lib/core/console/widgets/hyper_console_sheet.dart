import 'package:flutter/material.dart';

import 'tabs/network_tester_tab.dart';
import 'tabs/cache_viewer_tab.dart';
import 'tabs/device_theme_tab.dart';
import 'tabs/router_tab.dart';
import 'tabs/logger_tab.dart';

/// HyperConsole Sheet
///
/// Modal bottom sheet that contains all debug tools in tabs.
/// Opens when the HyperConsole button is tapped.
class HyperConsoleSheet extends StatelessWidget {
  const HyperConsoleSheet({super.key});

  /// Show the console sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HyperConsoleSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // 70% of screen height, respecting safe area
    final sheetHeight = mediaQuery.size.height * 0.7;

    return Container(
      height: sheetHeight,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            // Header with close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.developer_mode,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'HyperConsole',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodySmall?.color,
                indicatorColor: theme.colorScheme.primary,
                indicatorWeight: 3,
                tabs: const [
                  Tab(icon: Icon(Icons.cloud), text: 'Network'),
                  Tab(icon: Icon(Icons.storage), text: 'Cache'),
                  Tab(icon: Icon(Icons.phone_android), text: 'Device'),
                  Tab(icon: Icon(Icons.route), text: 'Router'),
                  Tab(icon: Icon(Icons.article), text: 'Logs'),
                ],
              ),
            ),

            // Tab Views
            const Expanded(
              child: TabBarView(
                children: [
                  NetworkTesterTab(),
                  CacheViewerTab(),
                  DeviceThemeTab(),
                  RouterTab(),
                  LoggerTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
