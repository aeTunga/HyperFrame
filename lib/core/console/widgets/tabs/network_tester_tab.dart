import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../network/network_manager.dart';
import '../../../network/exceptions/network_exceptions.dart';
import '../../../init/log_helper.dart';
import '../../models/network_test_result.dart';

/// Network Tester Tab
///
/// Debug tool for testing NetworkManager with real API calls.
/// Tests success scenarios, error handling, and interceptors.
class NetworkTesterTab extends StatefulWidget {
  const NetworkTesterTab({super.key});

  @override
  State<NetworkTesterTab> createState() => _NetworkTesterTabState();
}

class _NetworkTesterTabState extends State<NetworkTesterTab> {
  NetworkTestResult? _lastResult;
  bool _isLoading = false;

  /// Test successful request to JSONPlaceholder
  Future<void> _testSuccessRequest() async {
    setState(() => _isLoading = true);

    final stopwatch = Stopwatch()..start();

    try {
      // Use NetworkManager's raw dio instance to bypass BaseModel requirement
      final dio = NetworkManager.instance.dio;
      final response = await dio.get(
        'https://jsonplaceholder.typicode.com/users/1',
      );

      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.success(
          endpoint: 'jsonplaceholder.typicode.com/users/1',
          method: 'GET',
          statusCode: response.statusCode ?? 200,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          responseData: response.data,
        );
      });

      LogHelper.info(
        '✅ Success test completed: ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e) {
      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'jsonplaceholder.typicode.com/users/1',
          method: 'GET',
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.toString(),
          errorType: e.runtimeType.toString(),
        );
      });

      LogHelper.error('❌ Success test failed', error: e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Test 401 Unauthorized error
  Future<void> _test401Error() async {
    setState(() => _isLoading = true);

    final stopwatch = Stopwatch()..start();

    try {
      final dio = NetworkManager.instance.dio;
      final response = await dio.get('https://httpstat.us/401');

      stopwatch.stop();

      // If we get here, the request "succeeded" (status was returned)
      setState(() {
        _lastResult = NetworkTestResult.success(
          endpoint: 'httpstat.us/401',
          method: 'GET',
          statusCode: response.statusCode ?? 401,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          responseData: response.data,
        );
      });
    } on DioException catch (e) {
      stopwatch.stop();

      final statusCode = e.response?.statusCode;
      final errorType = e.error is NetworkException
          ? (e.error as NetworkException).runtimeType.toString()
          : 'DioException';

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'httpstat.us/401',
          method: 'GET',
          statusCode: statusCode,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.message ?? 'Unauthorized',
          errorType: errorType,
        );
      });

      LogHelper.info('✅ 401 test completed - Error caught correctly');
    } catch (e) {
      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'httpstat.us/401',
          method: 'GET',
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.toString(),
          errorType: e.runtimeType.toString(),
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Test timeout scenario
  Future<void> _testTimeout() async {
    setState(() => _isLoading = true);

    final stopwatch = Stopwatch()..start();

    try {
      final dio = NetworkManager.instance.dio;

      // This endpoint will delay for 35 seconds (our timeout is 30s)
      final response = await dio.get(
        'https://httpstat.us/200?sleep=35000',
        options: Options(
          receiveTimeout: const Duration(
            seconds: 5,
          ), // Short timeout for testing
        ),
      );

      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.success(
          endpoint: 'httpstat.us/200?sleep=35000',
          method: 'GET',
          statusCode: response.statusCode ?? 200,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          responseData: response.data,
        );
      });
    } on DioException catch (e) {
      stopwatch.stop();

      final errorType = e.type == DioExceptionType.receiveTimeout
          ? 'TimeoutException'
          : e.error is NetworkException
          ? (e.error as NetworkException).runtimeType.toString()
          : 'DioException';

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'httpstat.us/200?sleep=35000',
          method: 'GET',
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.message ?? 'Request timeout',
          errorType: errorType,
        );
      });

      LogHelper.info('✅ Timeout test completed - Timeout caught correctly');
    } catch (e) {
      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'httpstat.us/200?sleep=35000',
          method: 'GET',
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.toString(),
          errorType: e.runtimeType.toString(),
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Test 404 Not Found error
  Future<void> _test404Error() async {
    setState(() => _isLoading = true);

    final stopwatch = Stopwatch()..start();

    try {
      final dio = NetworkManager.instance.dio;
      final response = await dio.get('https://httpstat.us/404');

      stopwatch.stop();

      setState(() {
        _lastResult = NetworkTestResult.success(
          endpoint: 'httpstat.us/404',
          method: 'GET',
          statusCode: response.statusCode ?? 404,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          responseData: response.data,
        );
      });
    } catch (e) {
      stopwatch.stop();

      final statusCode = e is DioException ? e.response?.statusCode : null;

      setState(() {
        _lastResult = NetworkTestResult.failure(
          endpoint: 'httpstat.us/404',
          method: 'GET',
          statusCode: statusCode,
          responseTimeMs: stopwatch.elapsedMilliseconds,
          errorMessage: e.toString(),
          errorType: e.runtimeType.toString(),
        );
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            '🌐 Network Tester',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Test NetworkManager with real API calls',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 24),

          // Test Buttons
          _TestButton(
            label: 'Test Success Request',
            icon: Icons.check_circle_outline,
            color: Colors.green,
            onPressed: _isLoading ? null : _testSuccessRequest,
            description: 'GET jsonplaceholder.typicode.com/users/1',
          ),
          const SizedBox(height: 12),

          _TestButton(
            label: 'Test 401 Unauthorized',
            icon: Icons.lock_outline,
            color: Colors.orange,
            onPressed: _isLoading ? null : _test401Error,
            description: 'GET httpstat.us/401',
          ),
          const SizedBox(height: 12),

          _TestButton(
            label: 'Test 404 Not Found',
            icon: Icons.search_off,
            color: Colors.red,
            onPressed: _isLoading ? null : _test404Error,
            description: 'GET httpstat.us/404',
          ),
          const SizedBox(height: 12),

          _TestButton(
            label: 'Test Timeout (5s)',
            icon: Icons.timer_off_outlined,
            color: Colors.purple,
            onPressed: _isLoading ? null : _testTimeout,
            description: 'GET httpstat.us/200?sleep=35000',
          ),
          const SizedBox(height: 24),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
            ),

          // Last Result Card
          if (_lastResult != null && !_isLoading) ...[
            const Divider(height: 32),
            Text(
              'Last Request Result',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _ResultCard(result: _lastResult!),
          ],
        ],
      ),
    );
  }
}

/// Test Button Widget
class _TestButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final String description;

  const _TestButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Result Card Widget
class _ResultCard extends StatelessWidget {
  final NetworkTestResult result;

  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSuccess = result.success;
    final statusColor = isSuccess ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: statusColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isSuccess ? 'Success' : 'Failed',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(result.timeAgo, style: theme.textTheme.bodySmall),
              ],
            ),
            const Divider(height: 24),

            // Request Details
            _DetailRow(
              label: 'Endpoint',
              value: result.endpoint,
              icon: Icons.link,
            ),
            const SizedBox(height: 8),
            _DetailRow(label: 'Method', value: result.method, icon: Icons.http),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Status Code',
              value: result.statusText,
              icon: Icons.info_outline,
              valueColor:
                  result.statusCode != null &&
                      result.statusCode! >= 200 &&
                      result.statusCode! < 300
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(height: 8),
            _DetailRow(
              label: 'Response Time',
              value: result.formattedResponseTime,
              icon: Icons.timer,
              valueColor: result.responseTimeMs < 1000
                  ? Colors.green
                  : Colors.orange,
            ),

            // Error Details
            if (!isSuccess) ...[
              const Divider(height: 24),
              _DetailRow(
                label: 'Error Type',
                value: result.errorType ?? 'Unknown',
                icon: Icons.warning_amber,
                valueColor: Colors.red,
              ),
              const SizedBox(height: 8),
              _DetailRow(
                label: 'Error Message',
                value: result.errorMessage ?? 'No message',
                icon: Icons.message,
                valueColor: Colors.red,
                maxLines: 3,
              ),
            ],

            // Response Data Preview
            if (isSuccess && result.responseData != null) ...[
              const Divider(height: 24),
              Row(
                children: [
                  const Icon(Icons.data_object, size: 16),
                  const SizedBox(width: 8),
                  Text('Response Data', style: theme.textTheme.labelLarge),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  result.responseData.toString(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'Courier',
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Detail Row Widget
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final int maxLines;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color?.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: valueColor,
                    fontFamily: maxLines == 1 ? 'Courier' : null,
                  ),
                ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
