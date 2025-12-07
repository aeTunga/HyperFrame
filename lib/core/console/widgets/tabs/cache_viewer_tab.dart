import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../caching/cache_manager.dart';
import '../../../init/log_helper.dart';

/// Cache Viewer Tab
///
/// Debug tool for inspecting and managing SharedPreferences cache.
/// Displays all cached keys and values with ability to refresh and clear.
class CacheViewerTab extends StatefulWidget {
  const CacheViewerTab({super.key});

  @override
  State<CacheViewerTab> createState() => _CacheViewerTabState();
}

class _CacheViewerTabState extends State<CacheViewerTab> {
  Map<String, dynamic> _cacheData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCacheData();
  }

  /// Load all cache data
  Future<void> _loadCacheData() async {
    setState(() => _isLoading = true);

    try {
      final keys = await CacheManager.instance.getAllKeys();
      final data = <String, dynamic>{};

      for (final key in keys) {
        // Try to get value in different types
        final stringValue = await CacheManager.instance.getString(key);
        if (stringValue != null) {
          // Try to parse as JSON
          try {
            final jsonValue = jsonDecode(stringValue);
            data[key] = jsonValue;
          } catch (_) {
            // Not JSON, store as string
            data[key] = stringValue;
          }
          continue;
        }

        final intValue = await CacheManager.instance.getInt(key);
        if (intValue != null) {
          data[key] = intValue;
          continue;
        }

        final boolValue = await CacheManager.instance.getBool(key);
        if (boolValue != null) {
          data[key] = boolValue;
          continue;
        }

        final doubleValue = await CacheManager.instance.getDouble(key);
        if (doubleValue != null) {
          data[key] = doubleValue;
          continue;
        }

        final listValue = await CacheManager.instance.getStringList(key);
        if (listValue != null) {
          data[key] = listValue;
          continue;
        }
      }

      setState(() {
        _cacheData = data;
      });

      LogHelper.info('✅ Loaded ${data.length} cache entries');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to load cache data',
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading cache: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Clear all cache with confirmation
  Future<void> _clearAllCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cache'),
        content: const Text(
          'Are you sure you want to delete all cached data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await CacheManager.instance.clearAll();
      await _loadCacheData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ All cache cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  /// Remove specific key
  Future<void> _removeKey(String key) async {
    await CacheManager.instance.remove(key);
    await _loadCacheData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ Removed: $key'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Copy value to clipboard
  Future<void> _copyValue(String key, dynamic value) async {
    final stringValue = value is String ? value : jsonEncode(value);
    await Clipboard.setData(ClipboardData(text: stringValue));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📋 Copied: $key'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💾 Cache Viewer',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_cacheData.length} items stored',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _loadCacheData,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                  IconButton(
                    onPressed: _cacheData.isEmpty ? null : _clearAllCache,
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Clear All',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Cache List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _cacheData.isEmpty
              ? _EmptyState(onRefresh: _loadCacheData)
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _cacheData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final key = _cacheData.keys.elementAt(index);
                    final value = _cacheData[key];

                    return _CacheItem(
                      cacheKey: key,
                      value: value,
                      onRemove: () => _removeKey(key),
                      onCopy: () => _copyValue(key, value),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Empty State Widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.iconTheme.color?.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Cached Data',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cache is empty or has been cleared',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

/// Cache Item Widget
class _CacheItem extends StatelessWidget {
  final String cacheKey;
  final dynamic value;
  final VoidCallback onRemove;
  final VoidCallback onCopy;

  const _CacheItem({
    required this.cacheKey,
    required this.value,
    required this.onRemove,
    required this.onCopy,
  });

  IconData _getTypeIcon() {
    if (value is bool) return Icons.toggle_on;
    if (value is int) return Icons.numbers;
    if (value is double) return Icons.format_quote;
    if (value is List) return Icons.list;
    if (value is Map) return Icons.data_object;
    return Icons.text_fields;
  }

  Color _getTypeColor() {
    if (value is bool) return Colors.purple;
    if (value is int) return Colors.blue;
    if (value is double) return Colors.cyan;
    if (value is List) return Colors.orange;
    if (value is Map) return Colors.green;
    return Colors.grey;
  }

  String _getTypeName() {
    if (value is bool) return 'Boolean';
    if (value is int) return 'Integer';
    if (value is double) return 'Double';
    if (value is List) return 'List';
    if (value is Map) return 'Object';
    return 'String';
  }

  String _getFormattedValue() {
    if (value is Map || value is List) {
      try {
        return const JsonEncoder.withIndent('  ').convert(value);
      } catch (_) {
        return value.toString();
      }
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key and Type
            Row(
              children: [
                Icon(_getTypeIcon(), size: 20, color: typeColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cacheKey,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: typeColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _getTypeName(),
                    style: TextStyle(
                      fontSize: 11,
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Value
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _getFormattedValue(),
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'Courier',
                ),
                maxLines: value is Map || value is List ? 10 : 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Remove'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
