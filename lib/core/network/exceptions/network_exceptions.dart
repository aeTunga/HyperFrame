import 'package:equatable/equatable.dart';

/// Network Exception Types
///
/// Sealed class hierarchy for type-safe error handling.
/// Each exception type represents a specific failure scenario.
///
/// **Usage:**
/// ```dart
/// try {
///   await networkManager.send(...);
/// } on NetworkException catch (e) {
///   if (e is ServerException) {
///     // Handle server error
///   } else if (e is ConnectionException) {
///     // Handle connection error
///   }
/// }
/// ```
sealed class NetworkException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const NetworkException({required this.message, this.statusCode, this.data});

  @override
  List<Object?> get props => [message, statusCode, data];

  @override
  String toString() {
    if (statusCode != null) {
      return '$runtimeType: [$statusCode] $message';
    }
    return '$runtimeType: $message';
  }
}

/// Server returned an error response (4xx, 5xx)
class ServerException extends NetworkException {
  const ServerException({required super.message, super.statusCode, super.data});
}

/// Network connection failed
class ConnectionException extends NetworkException {
  const ConnectionException({required super.message, super.data});
}

/// Request timeout
class TimeoutException extends NetworkException {
  const TimeoutException({required super.message, super.data});
}

/// Authentication failed (401, 403)
class UnauthorizedException extends NetworkException {
  const UnauthorizedException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

/// Request data parsing failed
class ParsingException extends NetworkException {
  const ParsingException({required super.message, super.data});
}

/// Request cancelled by user
class CancelException extends NetworkException {
  const CancelException({required super.message, super.data});
}

/// Unknown/unexpected error
class UnknownException extends NetworkException {
  const UnknownException({required super.message, super.data});
}
