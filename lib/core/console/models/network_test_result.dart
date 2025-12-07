/// Network Test Result Model
///
/// Stores the result of a network test including timing, status, and response data.
class NetworkTestResult {
  final String endpoint;
  final String method;
  final int? statusCode;
  final int responseTimeMs;
  final bool success;
  final String? errorMessage;
  final String? errorType;
  final dynamic responseData;
  final DateTime timestamp;

  const NetworkTestResult({
    required this.endpoint,
    required this.method,
    this.statusCode,
    required this.responseTimeMs,
    required this.success,
    this.errorMessage,
    this.errorType,
    this.responseData,
    required this.timestamp,
  });

  /// Create a successful result
  factory NetworkTestResult.success({
    required String endpoint,
    required String method,
    required int statusCode,
    required int responseTimeMs,
    dynamic responseData,
  }) {
    return NetworkTestResult(
      endpoint: endpoint,
      method: method,
      statusCode: statusCode,
      responseTimeMs: responseTimeMs,
      success: true,
      responseData: responseData,
      timestamp: DateTime.now(),
    );
  }

  /// Create a failed result
  factory NetworkTestResult.failure({
    required String endpoint,
    required String method,
    required int responseTimeMs,
    int? statusCode,
    required String errorMessage,
    required String errorType,
  }) {
    return NetworkTestResult(
      endpoint: endpoint,
      method: method,
      statusCode: statusCode,
      responseTimeMs: responseTimeMs,
      success: false,
      errorMessage: errorMessage,
      errorType: errorType,
      timestamp: DateTime.now(),
    );
  }

  /// Get formatted status code string
  String get statusText {
    if (statusCode == null) return 'N/A';
    return '$statusCode ${_getStatusName(statusCode!)}';
  }

  /// Get status code name
  String _getStatusName(int code) {
    switch (code) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 204:
        return 'No Content';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      default:
        return '';
    }
  }

  /// Get formatted response time
  String get formattedResponseTime {
    if (responseTimeMs < 1000) {
      return '${responseTimeMs}ms';
    } else {
      final seconds = (responseTimeMs / 1000).toStringAsFixed(2);
      return '${seconds}s';
    }
  }

  /// Get time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }
}
