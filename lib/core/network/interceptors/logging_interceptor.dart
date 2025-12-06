import 'package:dio/dio.dart';

import '../../init/log_helper.dart';

/// Logging Interceptor
///
/// Dio interceptor that logs all HTTP requests, responses, and errors.
/// Provides detailed information for debugging network operations.
///
/// **Features:**
/// - Request logging (method, URL, headers, body)
/// - Response logging (status code, data)
/// - Error logging with stack traces
/// - Color-coded output for easy reading
/// - Automatic disabling in release mode (via LogHelper)
///
/// **Usage:**
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(LoggingInterceptor());
/// ```
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LogHelper.section('HTTP REQUEST');
    LogHelper.info('🌐 ${options.method} ${options.uri}');

    if (options.headers.isNotEmpty) {
      LogHelper.debug('📋 Headers: ${options.headers}');
    }

    if (options.data != null) {
      LogHelper.debug('📦 Body: ${options.data}');
    }

    if (options.queryParameters.isNotEmpty) {
      LogHelper.debug('🔍 Query: ${options.queryParameters}');
    }

    LogHelper.separator();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LogHelper.section('HTTP RESPONSE');
    LogHelper.info(
      '✅ ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
    );

    if (response.data != null) {
      LogHelper.debug('📥 Response: ${response.data}');
    }

    LogHelper.separator();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LogHelper.section('HTTP ERROR');
    LogHelper.error(
      '❌ ${err.requestOptions.method} ${err.requestOptions.uri}',
      error: err,
    );

    if (err.response != null) {
      LogHelper.error('📛 Status: ${err.response?.statusCode}');
      LogHelper.error('📛 Data: ${err.response?.data}');
    } else {
      LogHelper.error('📛 Type: ${err.type}');
      LogHelper.error('📛 Message: ${err.message}');
    }

    LogHelper.separator();
    super.onError(err, handler);
  }
}
