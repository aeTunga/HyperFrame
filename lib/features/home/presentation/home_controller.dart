import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

/// Counter State Management with Riverpod
///
/// Simple counter controller for hot reload testing.
/// Demonstrates Riverpod's state management approach.
@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0; // Initial counter value
  }

  /// Increment counter by 1
  void increment() {
    state++;
  }

  /// Decrement counter by 1
  void decrement() {
    state--;
  }

  /// Reset counter to 0
  void reset() {
    state = 0;
  }
}
