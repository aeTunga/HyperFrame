import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../init/log_helper.dart';
import 'base_model.dart';
import 'exceptions/network_exceptions.dart';
import 'http_method.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Network Manager - HTTP Client Singleton
///
/// Generic HTTP client wrapper using Dio for all network operations.
/// Provides type-safe methods for making API requests with automatic
/// serialization/deserialization.
///
/// **Features:**
/// - Singleton pattern for consistent configuration
/// - Generic type-safe methods
/// - Automatic JSON parsing
/// - Interceptors for logging, errors, and authentication
/// - Timeout configuration
/// - BaseModel integration
///
/// **Usage:**
/// ```dart
/// // Initialize (called once in main)
/// await NetworkManager.instance.init();
///
/// // Make a GET request
/// final user = await NetworkManager.instance.send<UserModel>(
///   '/users/123',
///   method: HttpMethod.get,
///   fromJson: UserModel.fromJson,
/// );
///
/// // Make a POST request
/// final newUser = await NetworkManager.instance.send<UserModel>(
///   '/users',
///   method: HttpMethod.post,
///   data: {'name': 'John', 'email': 'john@example.com'},
///   fromJson: UserModel.fromJson,
/// );
/// ```
class NetworkManager {
  NetworkManager._internal();
  static final NetworkManager _instance = NetworkManager._internal();

  /// Singleton instance accessor
  static NetworkManager get instance => _instance;

  late final Dio _dio;

  /// Initialize Dio with configuration and interceptors
  ///
  /// Must be called before using any network operations.
  /// Typically called in main() before runApp().
  ///
  /// ```dart
  /// await NetworkManager.instance.init();
  /// ```
  Future<void> init() async {
    try {
      _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          sendTimeout: AppConstants.sendTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            // Accept all status codes, let interceptor handle errors
            return status != null && status < 500;
          },
        ),
      );

      // Add interceptors in order
      _dio.interceptors.addAll([
        TokenInterceptor(), // Must be first to inject token
        LoggingInterceptor(),
        ErrorInterceptor(),
      ]);

      LogHelper.info(
        '✅ NetworkManager initialized with base: ${AppConstants.baseUrl}',
      );
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to initialize NetworkManager',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Generic HTTP request method
  ///
  /// Handles all HTTP methods with automatic type conversion.
  ///
  /// **Type Parameters:**
  /// - `T extends BaseModel`: Response model type
  ///
  /// **Parameters:**
  /// - `path`: API endpoint path (relative to baseUrl)
  /// - `method`: HTTP method (get, post, put, patch, delete)
  /// - `fromJson`: Factory function to convert JSON to model
  /// - `data`: Request body (for POST, PUT, PATCH)
  /// - `queryParameters`: URL query parameters
  /// - `headers`: Additional request headers
  ///
  /// **Returns:**
  /// - `Future<T?>`: Parsed model instance or null if response is empty
  ///
  /// **Throws:**
  /// - `NetworkException`: On any network error
  ///
  /// **Example:**
  /// ```dart
  /// final user = await NetworkManager.instance.send<UserModel>(
  ///   '/users/123',
  ///   method: HttpMethod.get,
  ///   fromJson: UserModel.fromJson,
  /// );
  /// ```
  Future<T?> send<T extends BaseModel>({
    required String path,
    required HttpMethod method,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      LogHelper.debug('📡 Sending ${method.value} request to: $path');

      final Response<dynamic> response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.head:
          response = await _dio.head(
            path,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.options:
          response = await _dio.fetch(
            RequestOptions(
              path: path,
              method: 'OPTIONS',
              baseUrl: _dio.options.baseUrl,
              queryParameters: queryParameters,
              headers: headers,
            ),
          );
          break;
      }

      // Parse response
      return _parseResponse<T>(response, fromJson);
    } on DioException catch (e) {
      // DioException already processed by ErrorInterceptor
      // Extract NetworkException from error property
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }

      // Fallback if interceptor didn't catch it
      throw UnknownException(
        message: e.message ?? 'Network request failed',
        data: e.response?.data,
      );
    } catch (e, stackTrace) {
      LogHelper.error(
        'Unexpected error in send()',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Parse response data to model instance
  T? _parseResponse<T extends BaseModel>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      if (response.data == null) {
        LogHelper.debug('Empty response body');
        return null;
      }

      // Handle response data
      final dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        // Direct object response
        final model = fromJson(data);
        LogHelper.debug('✅ Parsed response to ${T.toString()}');
        return model;
      } else if (data is List) {
        // List response - throw error, use sendList() instead
        throw ParsingException(
          message:
              'Expected single object but got list. Use sendList() method.',
          data: data,
        );
      } else {
        throw ParsingException(
          message: 'Unexpected response type: ${data.runtimeType}',
          data: data,
        );
      }
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to parse response',
        error: e,
        stackTrace: stackTrace,
      );

      if (e is NetworkException) rethrow;

      throw ParsingException(
        message: 'Failed to parse response: ${e.toString()}',
        data: response.data,
      );
    }
  }

  /// Send request and expect list response
  ///
  /// Use this method when API returns an array of objects.
  ///
  /// **Example:**
  /// ```dart
  /// final users = await NetworkManager.instance.sendList<UserModel>(
  ///   '/users',
  ///   method: HttpMethod.get,
  ///   fromJson: UserModel.fromJson,
  /// );
  /// ```
  Future<List<T>> sendList<T extends BaseModel>({
    required String path,
    required HttpMethod method,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      LogHelper.debug('📡 Sending ${method.value} request (list) to: $path');

      final Response<dynamic> response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;

        case HttpMethod.put:
        case HttpMethod.patch:
        case HttpMethod.delete:
        case HttpMethod.head:
        case HttpMethod.options:
          throw UnknownException(
            message: 'Method ${method.value} not supported for list operations',
          );
      }

      // Parse list response
      return _parseListResponse<T>(response, fromJson);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw UnknownException(
        message: e.message ?? 'Network request failed',
        data: e.response?.data,
      );
    } catch (e, stackTrace) {
      LogHelper.error(
        'Unexpected error in sendList()',
        error: e,
        stackTrace: stackTrace,
      );
      throw UnknownException(
        message: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Parse list response
  List<T> _parseListResponse<T extends BaseModel>(
    Response<dynamic> response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      if (response.data == null) {
        LogHelper.debug('Empty response body');
        return [];
      }

      final dynamic data = response.data;

      if (data is List) {
        final list = data
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
        LogHelper.debug(
          '✅ Parsed ${list.length} items to List<${T.toString()}>',
        );
        return list;
      } else {
        throw ParsingException(
          message: 'Expected list but got ${data.runtimeType}',
          data: data,
        );
      }
    } catch (e, stackTrace) {
      LogHelper.error(
        'Failed to parse list response',
        error: e,
        stackTrace: stackTrace,
      );

      if (e is NetworkException) rethrow;

      throw ParsingException(
        message: 'Failed to parse list response: ${e.toString()}',
        data: response.data,
      );
    }
  }

  /// Get direct Dio instance for advanced use cases
  ///
  /// Use with caution - bypasses NetworkManager abstractions.
  Dio get dio => _dio;
}
