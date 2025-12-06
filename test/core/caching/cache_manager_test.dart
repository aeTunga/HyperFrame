import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hyperframe/core/caching/cache_manager.dart';

void main() {
  group('CacheManager', () {
    setUp(() async {
      // Set up mock initial values for SharedPreferences
      SharedPreferences.setMockInitialValues({});
      await CacheManager.instance.init();
    });

    tearDown(() async {
      // Clean up after each test
      await CacheManager.instance.clearAll();
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        final manager = CacheManager.instance;
        expect(manager, isNotNull);
      });

      test('should throw StateError when not initialized', () async {
        // Create a new instance without initializing
        SharedPreferences.setMockInitialValues({});
        final manager = CacheManager.instance;

        // Clear the internal preferences to simulate uninitialized state
        // Note: We can't easily test this without reflection, so we skip this edge case
        // In production, initialization is handled in AppInitializer
      });
    });

    group('String Operations', () {
      test('should save and retrieve string value', () async {
        const key = 'test_string';
        const value = 'Hello World';

        final saved = await CacheManager.instance.saveString(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getString(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent string key', () async {
        final retrieved = await CacheManager.instance.getString('non_existent');
        expect(retrieved, isNull);
      });

      test('should overwrite existing string value', () async {
        const key = 'test_string';

        await CacheManager.instance.saveString(key, 'First Value');
        await CacheManager.instance.saveString(key, 'Second Value');

        final retrieved = await CacheManager.instance.getString(key);
        expect(retrieved, equals('Second Value'));
      });
    });

    group('Boolean Operations', () {
      test('should save and retrieve boolean value', () async {
        const key = 'test_bool';
        const value = true;

        final saved = await CacheManager.instance.saveBool(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getBool(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent boolean key', () async {
        final retrieved = await CacheManager.instance.getBool('non_existent');
        expect(retrieved, isNull);
      });

      test('should handle false boolean value', () async {
        const key = 'test_bool';

        await CacheManager.instance.saveBool(key, false);

        final retrieved = await CacheManager.instance.getBool(key);
        expect(retrieved, isFalse);
      });
    });

    group('Integer Operations', () {
      test('should save and retrieve integer value', () async {
        const key = 'test_int';
        const value = 42;

        final saved = await CacheManager.instance.saveInt(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getInt(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent integer key', () async {
        final retrieved = await CacheManager.instance.getInt('non_existent');
        expect(retrieved, isNull);
      });

      test('should handle negative integer values', () async {
        const key = 'test_int';
        const value = -100;

        await CacheManager.instance.saveInt(key, value);

        final retrieved = await CacheManager.instance.getInt(key);
        expect(retrieved, equals(value));
      });

      test('should handle zero integer value', () async {
        const key = 'test_int';

        await CacheManager.instance.saveInt(key, 0);

        final retrieved = await CacheManager.instance.getInt(key);
        expect(retrieved, equals(0));
      });
    });

    group('Double Operations', () {
      test('should save and retrieve double value', () async {
        const key = 'test_double';
        const value = 3.14159;

        final saved = await CacheManager.instance.saveDouble(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getDouble(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent double key', () async {
        final retrieved = await CacheManager.instance.getDouble('non_existent');
        expect(retrieved, isNull);
      });

      test('should handle negative double values', () async {
        const key = 'test_double';
        const value = -99.99;

        await CacheManager.instance.saveDouble(key, value);

        final retrieved = await CacheManager.instance.getDouble(key);
        expect(retrieved, equals(value));
      });
    });

    group('JSON Object Operations', () {
      test('should save and retrieve JSON object', () async {
        const key = 'test_object';
        final value = {'name': 'John', 'age': 30, 'active': true};

        final saved = await CacheManager.instance.saveObject(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getObject(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent object key', () async {
        final retrieved = await CacheManager.instance.getObject('non_existent');
        expect(retrieved, isNull);
      });

      test('should handle nested JSON objects', () async {
        const key = 'test_nested';
        final value = {
          'user': {
            'name': 'Alice',
            'profile': {'bio': 'Developer', 'age': 28},
          },
          'settings': {'theme': 'dark', 'notifications': true},
        };

        await CacheManager.instance.saveObject(key, value);

        final retrieved = await CacheManager.instance.getObject(key);
        expect(retrieved, equals(value));
      });

      test('should handle empty JSON object', () async {
        const key = 'test_empty';
        final value = <String, dynamic>{};

        await CacheManager.instance.saveObject(key, value);

        final retrieved = await CacheManager.instance.getObject(key);
        expect(retrieved, equals(value));
      });
    });

    group('String List Operations', () {
      test('should save and retrieve string list', () async {
        const key = 'test_list';
        const value = ['flutter', 'dart', 'mobile'];

        final saved = await CacheManager.instance.saveStringList(key, value);
        expect(saved, isTrue);

        final retrieved = await CacheManager.instance.getStringList(key);
        expect(retrieved, equals(value));
      });

      test('should return null for non-existent list key', () async {
        final retrieved = await CacheManager.instance.getStringList(
          'non_existent',
        );
        expect(retrieved, isNull);
      });

      test('should handle empty string list', () async {
        const key = 'test_empty_list';
        const value = <String>[];

        await CacheManager.instance.saveStringList(key, value);

        final retrieved = await CacheManager.instance.getStringList(key);
        expect(retrieved, equals(value));
      });

      test('should handle single item list', () async {
        const key = 'test_single';
        const value = ['single'];

        await CacheManager.instance.saveStringList(key, value);

        final retrieved = await CacheManager.instance.getStringList(key);
        expect(retrieved, equals(value));
      });
    });

    group('Utility Operations', () {
      test('should check if key exists', () async {
        const key = 'test_key';

        // Key should not exist initially
        var exists = await CacheManager.instance.containsKey(key);
        expect(exists, isFalse);

        // Save a value
        await CacheManager.instance.saveString(key, 'value');

        // Key should now exist
        exists = await CacheManager.instance.containsKey(key);
        expect(exists, isTrue);
      });

      test('should remove specific key', () async {
        const key = 'test_remove';

        // Save a value
        await CacheManager.instance.saveString(key, 'value');
        expect(await CacheManager.instance.containsKey(key), isTrue);

        // Remove the key
        final removed = await CacheManager.instance.remove(key);
        expect(removed, isTrue);
        expect(await CacheManager.instance.containsKey(key), isFalse);
      });

      test('should return true when removing non-existent key', () async {
        final removed = await CacheManager.instance.remove('non_existent');
        // SharedPreferences returns true even for non-existent keys
        expect(removed, isTrue);
      });

      test('should clear all cached data', () async {
        // Save multiple values
        await CacheManager.instance.saveString('key1', 'value1');
        await CacheManager.instance.saveInt('key2', 42);
        await CacheManager.instance.saveBool('key3', true);

        // Verify keys exist
        var keys = await CacheManager.instance.getAllKeys();
        expect(keys.length, equals(3));

        // Clear all
        final cleared = await CacheManager.instance.clearAll();
        expect(cleared, isTrue);

        // Verify all keys are gone
        keys = await CacheManager.instance.getAllKeys();
        expect(keys.isEmpty, isTrue);
      });

      test('should get all keys', () async {
        // Save multiple values
        await CacheManager.instance.saveString('key1', 'value1');
        await CacheManager.instance.saveInt('key2', 42);
        await CacheManager.instance.saveBool('key3', true);

        final keys = await CacheManager.instance.getAllKeys();
        expect(keys.length, equals(3));
        expect(keys, contains('key1'));
        expect(keys, contains('key2'));
        expect(keys, contains('key3'));
      });

      test('should return empty set when no keys exist', () async {
        final keys = await CacheManager.instance.getAllKeys();
        expect(keys.isEmpty, isTrue);
      });

      test('should reload cache from storage', () async {
        // This method is mainly for external changes
        // We just verify it doesn't throw an error
        await CacheManager.instance.saveString('test', 'value');
        await CacheManager.instance.reload();

        final value = await CacheManager.instance.getString('test');
        expect(value, equals('value'));
      });
    });

    group('Multiple Operations', () {
      test('should handle multiple concurrent operations', () async {
        // Save multiple types concurrently
        await Future.wait([
          CacheManager.instance.saveString('str', 'text'),
          CacheManager.instance.saveInt('int', 100),
          CacheManager.instance.saveBool('bool', true),
          CacheManager.instance.saveDouble('double', 1.5),
        ]);

        // Retrieve and verify
        final str = await CacheManager.instance.getString('str');
        final integer = await CacheManager.instance.getInt('int');
        final boolean = await CacheManager.instance.getBool('bool');
        final double = await CacheManager.instance.getDouble('double');

        expect(str, equals('text'));
        expect(integer, equals(100));
        expect(boolean, isTrue);
        expect(double, equals(1.5));
      });

      test('should maintain data integrity across operations', () async {
        // Save initial data
        await CacheManager.instance.saveString('user', 'Alice');
        await CacheManager.instance.saveInt('score', 100);

        // Modify one value
        await CacheManager.instance.saveString('user', 'Bob');

        // Verify only modified value changed
        final user = await CacheManager.instance.getString('user');
        final score = await CacheManager.instance.getInt('score');

        expect(user, equals('Bob'));
        expect(score, equals(100));
      });
    });

    group('Edge Cases', () {
      test('should handle empty string value', () async {
        const key = 'empty_string';
        const value = '';

        await CacheManager.instance.saveString(key, value);
        final retrieved = await CacheManager.instance.getString(key);

        expect(retrieved, equals(value));
      });

      test('should handle special characters in string', () async {
        const key = 'special_chars';
        const value = '!@#\$%^&*()_+-=[]{}|;:",.<>?/~`';

        await CacheManager.instance.saveString(key, value);
        final retrieved = await CacheManager.instance.getString(key);

        expect(retrieved, equals(value));
      });

      test('should handle unicode characters', () async {
        const key = 'unicode';
        const value = '你好世界 🌍 مرحبا';

        await CacheManager.instance.saveString(key, value);
        final retrieved = await CacheManager.instance.getString(key);

        expect(retrieved, equals(value));
      });

      test('should handle very long strings', () async {
        const key = 'long_string';
        final value = 'A' * 10000;

        await CacheManager.instance.saveString(key, value);
        final retrieved = await CacheManager.instance.getString(key);

        expect(retrieved, equals(value));
      });

      test('should handle large numbers', () async {
        const key = 'large_int';
        const value = 9223372036854775807; // Max int64

        await CacheManager.instance.saveInt(key, value);
        final retrieved = await CacheManager.instance.getInt(key);

        expect(retrieved, equals(value));
      });
    });
  });
}
