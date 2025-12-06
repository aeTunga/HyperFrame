/// Base Model Interface
///
/// Abstract base class that all data models must extend.
/// Enforces JSON serialization contract for network operations.
///
/// **Usage:**
/// ```dart
/// class UserModel extends BaseModel {
///   final String id;
///   final String name;
///
///   UserModel({required this.id, required this.name});
///
///   factory UserModel.fromJson(Map<String, dynamic> json) {
///     return UserModel(
///       id: json['id'] as String,
///       name: json['name'] as String,
///     );
///   }
///
///   @override
///   Map<String, dynamic> toJson() {
///     return {
///       'id': id,
///       'name': name,
///     };
///   }
/// }
/// ```
///
/// **Architecture Benefits:**
/// - Enforces consistent serialization pattern
/// - Type-safe network operations
/// - Easy to test and mock
/// - Works seamlessly with NetworkManager generic methods
abstract class BaseModel {
  /// Convert model to JSON Map
  ///
  /// This method must be implemented by all subclasses.
  /// Used for sending data in API requests.
  Map<String, dynamic> toJson();

  /// Base constructor
  const BaseModel();
}
