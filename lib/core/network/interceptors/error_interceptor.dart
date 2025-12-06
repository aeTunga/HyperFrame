import 'package:dio/dio.dart';

import '../../caching/cache_manager.dart';
import '../../constants/cache_keys.dart';
import '../../init/log_helper.dart';
import '../exceptions/network_exceptions.dart';

/// Error Interceptor
///
/// Dio interceptor that handles errors globally and converts them
/// into typed NetworkException instances for better error handling.
///
/// **Features:**
/// - Converts DioException to typed NetworkException
/// - Handles 401 Unauthorized (auto token refresh capability)
/// - Handles network connectivity errors
/// - Handles timeout errors
/// - Provides user-friendly error messages
///
/// **Usage:**
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(ErrorInterceptor());
/// ```
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    NetworkException networkException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        networkException = TimeoutException(
          message: 'Connection timeout. Please check your internet connection.',
          data: err.response?.data,
        );
        break;

      case DioExceptionType.badResponse:
        networkException = _handleBadResponse(err);
        break;

      case DioExceptionType.cancel:
        networkException = CancelException(
          message: 'Request was cancelled',
          data: err.response?.data,
        );
        break;

      case DioExceptionType.connectionError:
        networkException = ConnectionException(
          message: 'No internet connection. Please check your network.',
          data: err.response?.data,
        );
        break;

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        networkException = UnknownException(
          message: err.message ?? 'An unexpected error occurred',
          data: err.response?.data,
        );
        break;
    }

    LogHelper.error('Network Error Intercepted', error: networkException);

    // Reject with typed exception instead of DioException
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: networkException,
      ),
    );
  }

  /// Handle bad response errors (4xx, 5xx)
  NetworkException _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode;
    final data = err.response?.data;

    // Extract error message from response
    String message = 'Request failed';
    if (data is Map<String, dynamic>) {
      message =
          data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String? ??
          message;
    }

    // Handle specific status codes
    switch (statusCode) {
      case 401:
        return UnauthorizedException(
          message: 'Authentication failed. Please login again.',
          statusCode: statusCode,
          data: data,
        );

      case 403:
        return UnauthorizedException(
          message: 'Access denied. You don\'t have permission.',
          statusCode: statusCode,
          data: data,
        );

      case 404:
        return ServerException(
          message: 'Resource not found',
          statusCode: statusCode,
          data: data,
        );

      case 422:
        return ServerException(
          message: 'Validation failed: $message',
          statusCode: statusCode,
          data: data,
        );

      case 429:
        return ServerException(
          message: 'Too many requests. Please try again later.',
          statusCode: statusCode,
          data: data,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
          data: data,
        );

      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
          data: data,
        );
    }
  }
}

/// Token Interceptor
///
/// Dio interceptor that automatically adds authentication token
/// to all requests that require authentication.
///
/// **Features:**
/// - Auto-inject Bearer token from cache
/// - Skip token injection for public endpoints
/// - Token refresh capability (can be extended)
///
/// **Usage:**
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(TokenInterceptor());
/// ```
class TokenInterceptor extends Interceptor {
  /// Endpoints that don't require authentication
  static const _publicEndpoints = [
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if endpoint requires authentication
    final requiresAuth = !_publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    if (requiresAuth) {
      // Get token from cache
      final token = await CacheManager.instance.getString(
        CacheKeys.accessToken,
      );

      if (token != null && token.isNotEmpty) {
        // Add Bearer token to headers
        options.headers['Authorization'] = 'Bearer $token';
        LogHelper.debug('🔑 Token injected for ${options.path}');
      } else {
        LogHelper.warning('⚠️ No token found for authenticated endpoint');
      }
    }

    super.onRequest(options, handler);
  }
}
