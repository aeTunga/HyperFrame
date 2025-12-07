import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../caching/cache_manager.dart';
import '../../../init/log_helper.dart';
import '../../../constants/cache_keys.dart';

/// Router Manager Tab
///
/// Advanced navigation debugging tool for GoRouter.
///
/// **Features:**
/// - Live current route tracking with auto-updates
/// - Manual navigation with route + query parameter support
/// - Back/Forward browser-style navigation
/// - In-memory session history (last 20 routes)
/// - Persistent favorite routes via CacheManager
/// - Quick access buttons for common routes
/// - Error handling with SnackBar feedback
///
/// **User Preferences:**
/// - Console stays open after navigation
/// - In-memory history (not persisted)
/// - Favorite routes persisted to storage
class RouterTab extends StatefulWidget {
  const RouterTab({super.key});

  @override
  State<RouterTab> createState() => _RouterTabState();
}

class _RouterTabState extends State<RouterTab> {
  // ========================================================================
  // STATE VARIABLES
  // ========================================================================

  /// Current route path from GoRouter
  String _currentRoute = '/';

  /// TextField controller for manual navigation input
  final TextEditingController _pathController = TextEditingController();

  /// In-memory navigation history (session-only, last 20 entries)
  /// Format: {'path': '/home', 'timestamp': '14:32:15'}
  final List<Map<String, String>> _navigationHistory = [];

  /// Current position in navigation history (for back/forward)
  int _historyIndex = -1;

  /// Favorite routes loaded from CacheManager (persisted)
  List<String> _favoriteRoutes = [];

  /// Loading state for async operations
  bool _isLoading = false;

  /// GoRouter instance (cached for performance)
  GoRouter? _router;

  // ========================================================================
  // LIFECYCLE METHODS
  // ========================================================================

  @override
  void initState() {
    super.initState();
    _loadFavoriteRoutes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize router and current route
    _router = GoRouter.of(context);
    _currentRoute = _router!.routeInformationProvider.value.uri.toString();

    // Listen to route changes for live updates
    _router!.routeInformationProvider.addListener(_onRouteChanged);

    // Add initial route to history
    if (_navigationHistory.isEmpty) {
      _addToHistory(_currentRoute);
    }
  }

  @override
  void dispose() {
    _router?.routeInformationProvider.removeListener(_onRouteChanged);
    _pathController.dispose();
    super.dispose();
  }

  // ========================================================================
  // ROUTE CHANGE LISTENER
  // ========================================================================

  /// Called when GoRouter navigates to a new route
  void _onRouteChanged() {
    if (!mounted) return;

    setState(() {
      _currentRoute = _router!.routeInformationProvider.value.uri.toString();
    });

    LogHelper.debug('🧭 Route changed: $_currentRoute');
  }

  // ========================================================================
  // MANUAL NAVIGATION
  // ========================================================================

  /// Navigate to user-entered route path
  /// Supports routes with parameters and query strings
  /// Example: /user/123?edit=true
  void _navigateToRoute(String path) {
    // Validation: Empty path
    if (path.trim().isEmpty) {
      _showError('Please enter a route path');
      return;
    }

    // Validation: Must start with /
    if (!path.startsWith('/')) {
      _showError('Route must start with "/" (e.g., /home)');
      return;
    }

    try {
      // Navigate using context.go (supports params & query)
      context.go(path);

      // Add to history
      _addToHistory(path);

      // Show success feedback
      _showSuccess('Navigated to $path');

      // Clear input field for next entry
      _pathController.clear();

      // Keep console open (user preference)
      LogHelper.info('✅ Router navigation: $path');
    } catch (e, stackTrace) {
      // Handle invalid routes gracefully
      _showError('Invalid route: $path');
      LogHelper.error(
        'Router navigation failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  // ========================================================================
  // BACK/FORWARD NAVIGATION
  // ========================================================================

  /// Navigate backward in history (browser-style)
  void _navigateBack() {
    if (!_canGoBack()) return;

    setState(() {
      _historyIndex--;
    });

    final targetRoute = _navigationHistory[_historyIndex]['path']!;

    try {
      context.go(targetRoute);
      _showSuccess('⬅️ Back to $targetRoute');
      LogHelper.debug('⬅️ Back navigation: $targetRoute');
    } catch (e) {
      _showError('Failed to navigate back');
      setState(() {
        _historyIndex++; // Revert on error
      });
    }
  }

  /// Navigate forward in history (browser-style)
  void _navigateForward() {
    if (!_canGoForward()) return;

    setState(() {
      _historyIndex++;
    });

    final targetRoute = _navigationHistory[_historyIndex]['path']!;

    try {
      context.go(targetRoute);
      _showSuccess('➡️ Forward to $targetRoute');
      LogHelper.debug('➡️ Forward navigation: $targetRoute');
    } catch (e) {
      _showError('Failed to navigate forward');
      setState(() {
        _historyIndex--; // Revert on error
      });
    }
  }

  /// Check if back navigation is possible
  bool _canGoBack() {
    return _historyIndex > 0;
  }

  /// Check if forward navigation is possible
  bool _canGoForward() {
    return _historyIndex < _navigationHistory.length - 1;
  }

  // ========================================================================
  // HISTORY MANAGEMENT
  // ========================================================================

  /// Add route to navigation history (in-memory)
  /// Keeps last 20 entries
  void _addToHistory(String path) {
    final timestamp = DateTime.now();
    final entry = {
      'path': path,
      'timestamp':
          '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}:'
          '${timestamp.second.toString().padLeft(2, '0')}',
    };

    setState(() {
      // If we're in the middle of history, truncate forward entries
      if (_historyIndex < _navigationHistory.length - 1) {
        _navigationHistory.removeRange(
          _historyIndex + 1,
          _navigationHistory.length,
        );
      }

      // Add new entry
      _navigationHistory.add(entry);

      // Keep only last 20 entries
      if (_navigationHistory.length > 20) {
        _navigationHistory.removeAt(0);
      }

      // Update index to point to latest entry
      _historyIndex = _navigationHistory.length - 1;
    });
  }

  /// Clear all navigation history
  void _clearHistory() {
    setState(() {
      _navigationHistory.clear();
      _historyIndex = -1;

      // Re-add current route
      _addToHistory(_currentRoute);
    });

    _showSuccess('History cleared');
  }

  // ========================================================================
  // FAVORITE ROUTES MANAGEMENT
  // ========================================================================

  /// Load favorite routes from CacheManager
  Future<void> _loadFavoriteRoutes() async {
    setState(() => _isLoading = true);

    try {
      final jsonString = await CacheManager.instance.getString(
        CacheKeys.hyperConsoleFavoriteRoutes,
      );

      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        setState(() {
          _favoriteRoutes = decoded.cast<String>();
        });
        LogHelper.info('✅ Loaded ${_favoriteRoutes.length} favorite routes');
      }
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to load favorite routes',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Save favorite routes to CacheManager
  Future<void> _saveFavoriteRoutes() async {
    try {
      final jsonString = jsonEncode(_favoriteRoutes);
      await CacheManager.instance.saveString(
        CacheKeys.hyperConsoleFavoriteRoutes,
        jsonString,
      );
      LogHelper.info('💾 Saved ${_favoriteRoutes.length} favorite routes');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save favorite routes',
        error: e,
        stackTrace: stackTrace,
      );
      _showError('Failed to save favorites');
    }
  }

  /// Toggle favorite status for a route
  Future<void> _toggleFavorite(String path) async {
    setState(() {
      if (_favoriteRoutes.contains(path)) {
        _favoriteRoutes.remove(path);
        _showSuccess('⭐ Removed from favorites');
      } else {
        _favoriteRoutes.add(path);
        _showSuccess('⭐ Added to favorites');
      }
    });

    await _saveFavoriteRoutes();
  }

  /// Check if route is favorited
  bool _isFavorite(String path) {
    return _favoriteRoutes.contains(path);
  }

  // ========================================================================
  // UI FEEDBACK HELPERS
  // ========================================================================

  /// Show success SnackBar
  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show error SnackBar
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Copy route path to clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSuccess('📋 Copied: $text');
  }

  // ========================================================================
  // UI BUILD
  // ========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ============================================================
        // SECTION 1: CURRENT ROUTE DISPLAY
        // ============================================================
        _buildSectionHeader(
          icon: Icons.location_on,
          title: 'Current Route',
          theme: theme,
        ),
        const SizedBox(height: 8),
        _buildCurrentRouteCard(theme),

        const SizedBox(height: 24),

        // ============================================================
        // SECTION 2: BACK/FORWARD NAVIGATION
        // ============================================================
        _buildSectionHeader(
          icon: Icons.history,
          title: 'Browser Controls',
          theme: theme,
        ),
        const SizedBox(height: 8),
        _buildBrowserControls(theme),

        const SizedBox(height: 24),

        // ============================================================
        // SECTION 3: MANUAL NAVIGATION
        // ============================================================
        _buildSectionHeader(
          icon: Icons.edit_location_alt,
          title: 'Manual Navigation',
          theme: theme,
        ),
        const SizedBox(height: 8),
        _buildManualNavigationCard(theme),

        const SizedBox(height: 24),

        // ============================================================
        // SECTION 4: QUICK ACCESS ROUTES
        // ============================================================
        _buildSectionHeader(
          icon: Icons.bolt,
          title: 'Quick Access',
          theme: theme,
        ),
        const SizedBox(height: 8),
        _buildQuickAccessButtons(theme),

        const SizedBox(height: 24),

        // ============================================================
        // SECTION 5: FAVORITE ROUTES
        // ============================================================
        _buildSectionHeader(
          icon: Icons.star,
          title: 'Favorite Routes',
          theme: theme,
        ),
        const SizedBox(height: 8),
        _buildFavoriteRoutes(theme),

        const SizedBox(height: 24),

        // ============================================================
        // SECTION 6: NAVIGATION HISTORY
        // ============================================================
        _buildSectionHeader(
          icon: Icons.history_outlined,
          title: 'Session History (In-Memory)',
          theme: theme,
          trailing: _navigationHistory.length > 1
              ? TextButton.icon(
                  onPressed: _clearHistory,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Clear'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                )
              : null,
        ),
        const SizedBox(height: 8),
        _buildNavigationHistory(theme),
      ],
    );
  }

  // ========================================================================
  // UI COMPONENT BUILDERS
  // ========================================================================

  /// Section header with icon and title
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required ThemeData theme,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  /// Current route display card
  Widget _buildCurrentRouteCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: SelectableText(
                _currentRoute,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () => _copyToClipboard(_currentRoute),
              tooltip: 'Copy route',
            ),
            IconButton(
              icon: Icon(
                _isFavorite(_currentRoute) ? Icons.star : Icons.star_border,
                size: 20,
                color: _isFavorite(_currentRoute) ? Colors.amber : null,
              ),
              onPressed: () => _toggleFavorite(_currentRoute),
              tooltip: _isFavorite(_currentRoute)
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
          ],
        ),
      ),
    );
  }

  /// Back/Forward browser controls
  Widget _buildBrowserControls(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Back button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _canGoBack() ? _navigateBack : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Forward button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _canGoForward() ? _navigateForward : null,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Forward'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  foregroundColor: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // History position indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_historyIndex + 1}/${_navigationHistory.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Manual navigation input card
  Widget _buildManualNavigationCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _pathController,
              decoration: InputDecoration(
                hintText: 'Enter route path (e.g., /home or /user/1?edit=true)',
                prefixIcon: const Icon(Icons.edit_location_alt),
                suffixIcon: _pathController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _pathController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: _navigateToRoute,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _pathController.text.isEmpty
                  ? null
                  : () => _navigateToRoute(_pathController.text),
              icon: const Icon(Icons.navigation),
              label: const Text('GO'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tip: Supports route parameters (/user/123) and query strings (?key=value)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Quick access route buttons
  Widget _buildQuickAccessButtons(ThemeData theme) {
    final quickRoutes = [
      {'path': '/', 'label': 'Splash', 'icon': Icons.water_drop},
      {'path': '/home', 'label': 'Home', 'icon': Icons.home},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: quickRoutes.map((route) {
            final path = route['path'] as String;
            final label = route['label'] as String;
            final icon = route['icon'] as IconData;
            final isActive = _currentRoute == path;

            return ActionChip(
              avatar: Icon(icon, size: 18),
              label: Text(label),
              onPressed: () {
                context.go(path);
                _addToHistory(path);
                _showSuccess('Quick navigate to $path');
              },
              backgroundColor: isActive
                  ? theme.colorScheme.primaryContainer
                  : null,
              side: isActive
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Favorite routes list
  Widget _buildFavoriteRoutes(ThemeData theme) {
    if (_isLoading) {
      return const Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_favoriteRoutes.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No favorite routes yet.\nTap the ⭐ icon on any route to save it.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _favoriteRoutes.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: theme.dividerColor),
        itemBuilder: (context, index) {
          final route = _favoriteRoutes[index];
          return ListTile(
            leading: const Icon(Icons.star, color: Colors.amber, size: 20),
            title: Text(route, style: const TextStyle(fontFamily: 'monospace')),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.navigation, size: 20),
                  onPressed: () {
                    context.go(route);
                    _addToHistory(route);
                    _showSuccess('Navigated to $route');
                  },
                  tooltip: 'Navigate',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _toggleFavorite(route),
                  tooltip: 'Remove favorite',
                ),
              ],
            ),
            onTap: () {
              context.go(route);
              _addToHistory(route);
            },
          );
        },
      ),
    );
  }

  /// Navigation history list
  Widget _buildNavigationHistory(ThemeData theme) {
    if (_navigationHistory.isEmpty) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No navigation history yet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Reverse to show newest first
    final reversedHistory = _navigationHistory.reversed.toList();

    return Card(
      elevation: 2,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reversedHistory.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: theme.dividerColor),
        itemBuilder: (context, index) {
          final entry = reversedHistory[index];
          final path = entry['path']!;
          final timestamp = entry['timestamp']!;
          final actualIndex = _navigationHistory.length - 1 - index;
          final isCurrent = actualIndex == _historyIndex;

          return ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCurrent
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                timestamp,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            title: Text(
              path,
              style: TextStyle(
                fontFamily: 'monospace',
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCurrent ? theme.colorScheme.primary : null,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isFavorite(path) ? Icons.star : Icons.star_border,
                    size: 20,
                    color: _isFavorite(path) ? Colors.amber : null,
                  ),
                  onPressed: () => _toggleFavorite(path),
                  tooltip: _isFavorite(path)
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 20),
                  onPressed: () => _copyToClipboard(path),
                  tooltip: 'Copy route',
                ),
              ],
            ),
            onTap: isCurrent
                ? null
                : () {
                    context.go(path);
                    _showSuccess('Navigated to $path');
                  },
            tileColor: isCurrent
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                : null,
          );
        },
      ),
    );
  }
}
