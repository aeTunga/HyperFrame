import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../init/log_helper.dart';

/// Cache Manager - Local Persistence Layer
///
/// Singleton wrapper around SharedPreferences for type-safe local data storage.
/// Provides convenient methods for storing and retrieving primitive types and JSON objects.
///
/// **Usage:**
/// ```dart
/// await CacheManager.instance.saveString('key', 'value');
/// final value = await CacheManager.instance.getString('key');
/// ```
///
/// **Architecture:**
/// - Singleton pattern ensures single SharedPreferences instance
/// - All methods are async to prevent blocking UI thread
/// - Graceful error handling with logging
/// - Supports primitive types and JSON serialization
class CacheManager {
  CacheManager._internal();
  static final CacheManager _instance = CacheManager._internal();

  /// Singleton instance accessor
  static CacheManager get instance => _instance;

  SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  ///
  /// Must be called before using any cache operations.
  /// Typically called in main() before runApp().
  ///
  /// ```dart
  /// await CacheManager.instance.init();
  /// ```
  Future<void> init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      LogHelper.info('✅ CacheManager initialized successfully');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to initialize CacheManager',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Ensure SharedPreferences is initialized
  void _ensureInitialized() {
    if (_preferences == null) {
      throw StateError(
        'CacheManager not initialized. Call CacheManager.instance.init() first.',
      );
    }
  }

  // ========================================================================
  // STRING OPERATIONS
  // ========================================================================

  /// Save a string value
  ///
  /// ```dart
  /// await CacheManager.instance.saveString('username', 'john_doe');
  /// ```
  Future<bool> saveString(String key, String value) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.setString(key, value);
      LogHelper.debug('💾 Saved string: $key = $value');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save string: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get a string value
  ///
  /// Returns null if key doesn't exist.
  ///
  /// ```dart
  /// final username = await CacheManager.instance.getString('username');
  /// ```
  Future<String?> getString(String key) async {
    try {
      _ensureInitialized();
      final value = _preferences!.getString(key);
      LogHelper.debug('📖 Retrieved string: $key = $value');
      return value;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get string: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // BOOLEAN OPERATIONS
  // ========================================================================

  /// Save a boolean value
  ///
  /// ```dart
  /// await CacheManager.instance.saveBool('isDarkMode', true);
  /// ```
  Future<bool> saveBool(String key, bool value) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.setBool(key, value);
      LogHelper.debug('💾 Saved bool: $key = $value');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save bool: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get a boolean value
  ///
  /// Returns null if key doesn't exist.
  ///
  /// ```dart
  /// final isDarkMode = await CacheManager.instance.getBool('isDarkMode');
  /// ```
  Future<bool?> getBool(String key) async {
    try {
      _ensureInitialized();
      final value = _preferences!.getBool(key);
      LogHelper.debug('📖 Retrieved bool: $key = $value');
      return value;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get bool: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // INTEGER OPERATIONS
  // ========================================================================

  /// Save an integer value
  ///
  /// ```dart
  /// await CacheManager.instance.saveInt('userId', 12345);
  /// ```
  Future<bool> saveInt(String key, int value) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.setInt(key, value);
      LogHelper.debug('💾 Saved int: $key = $value');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save int: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get an integer value
  ///
  /// Returns null if key doesn't exist.
  ///
  /// ```dart
  /// final userId = await CacheManager.instance.getInt('userId');
  /// ```
  Future<int?> getInt(String key) async {
    try {
      _ensureInitialized();
      final value = _preferences!.getInt(key);
      LogHelper.debug('📖 Retrieved int: $key = $value');
      return value;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get int: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // DOUBLE OPERATIONS
  // ========================================================================

  /// Save a double value
  ///
  /// ```dart
  /// await CacheManager.instance.saveDouble('appVersion', 1.5);
  /// ```
  Future<bool> saveDouble(String key, double value) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.setDouble(key, value);
      LogHelper.debug('💾 Saved double: $key = $value');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save double: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get a double value
  ///
  /// Returns null if key doesn't exist.
  ///
  /// ```dart
  /// final version = await CacheManager.instance.getDouble('appVersion');
  /// ```
  Future<double?> getDouble(String key) async {
    try {
      _ensureInitialized();
      final value = _preferences!.getDouble(key);
      LogHelper.debug('📖 Retrieved double: $key = $value');
      return value;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get double: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // JSON OBJECT OPERATIONS
  // ========================================================================

  /// Save a JSON-serializable object
  ///
  /// Converts object to JSON string and stores it.
  ///
  /// ```dart
  /// final user = User(name: 'John', age: 30);
  /// await CacheManager.instance.saveObject('user', user.toJson());
  /// ```
  Future<bool> saveObject(String key, Map<String, dynamic> object) async {
    try {
      _ensureInitialized();
      final jsonString = jsonEncode(object);
      final result = await _preferences!.setString(key, jsonString);
      LogHelper.debug('💾 Saved object: $key');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save object: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get a JSON object
  ///
  /// Returns deserialized Map or null if not found.
  ///
  /// ```dart
  /// final userJson = await CacheManager.instance.getObject('user');
  /// if (userJson != null) {
  ///   final user = User.fromJson(userJson);
  /// }
  /// ```
  Future<Map<String, dynamic>?> getObject(String key) async {
    try {
      _ensureInitialized();
      final jsonString = _preferences!.getString(key);
      if (jsonString == null) return null;

      final object = jsonDecode(jsonString) as Map<String, dynamic>;
      LogHelper.debug('📖 Retrieved object: $key');
      return object;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get object: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // LIST OPERATIONS
  // ========================================================================

  /// Save a list of strings
  ///
  /// ```dart
  /// await CacheManager.instance.saveStringList('tags', ['flutter', 'dart']);
  /// ```
  Future<bool> saveStringList(String key, List<String> value) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.setStringList(key, value);
      LogHelper.debug('💾 Saved string list: $key (${value.length} items)');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to save string list: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get a list of strings
  ///
  /// Returns null if key doesn't exist.
  ///
  /// ```dart
  /// final tags = await CacheManager.instance.getStringList('tags');
  /// ```
  Future<List<String>?> getStringList(String key) async {
    try {
      _ensureInitialized();
      final value = _preferences!.getStringList(key);
      LogHelper.debug(
        '📖 Retrieved string list: $key (${value?.length} items)',
      );
      return value;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get string list: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  // ========================================================================
  // UTILITY OPERATIONS
  // ========================================================================

  /// Check if a key exists
  ///
  /// ```dart
  /// final exists = await CacheManager.instance.containsKey('username');
  /// ```
  Future<bool> containsKey(String key) async {
    try {
      _ensureInitialized();
      return _preferences!.containsKey(key);
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to check key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Remove a specific key
  ///
  /// ```dart
  /// await CacheManager.instance.remove('username');
  /// ```
  Future<bool> remove(String key) async {
    try {
      _ensureInitialized();
      final result = await _preferences!.remove(key);
      LogHelper.debug('🗑️ Removed key: $key');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to remove key: $key',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Clear all cached data
  ///
  /// **Warning:** This removes ALL stored data. Use with caution.
  ///
  /// ```dart
  /// await CacheManager.instance.clearAll();
  /// ```
  Future<bool> clearAll() async {
    try {
      _ensureInitialized();
      final result = await _preferences!.clear();
      LogHelper.warning('🧹 Cleared all cache data');
      return result;
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to clear cache',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Get all keys stored in cache
  ///
  /// ```dart
  /// final keys = await CacheManager.instance.getAllKeys();
  /// print('Cached keys: $keys');
  /// ```
  Future<Set<String>> getAllKeys() async {
    try {
      _ensureInitialized();
      return _preferences!.getKeys();
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to get all keys',
        error: e,
        stackTrace: stackTrace,
      );
      return {};
    }
  }

  /// Reload preferences from storage
  ///
  /// Useful if values changed externally.
  ///
  /// ```dart
  /// await CacheManager.instance.reload();
  /// ```
  Future<void> reload() async {
    try {
      _ensureInitialized();
      await _preferences!.reload();
      LogHelper.debug('🔄 Cache reloaded from storage');
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to reload cache',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
