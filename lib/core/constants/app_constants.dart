/// Application-wide Constants
///
/// Centralized configuration for network, timeouts, and environment settings.
/// This ensures consistent values across the entire application.
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // ========================================================================
  // NETWORK CONFIGURATION
  // ========================================================================

  // Environment URLs
  static const String _devBaseUrl = 'https://dev-api.hyperframe.io';
  static const String _stagingBaseUrl = 'https://staging-api.hyperframe.io';
  static const String _prodBaseUrl = 'https://api.hyperframe.io';

  /// Base URL for API endpoints
  ///
  /// Environment-based URL selection using --dart-define:
  /// ```bash
  /// # Development (default)
  /// flutter run
  ///
  /// # Staging
  /// flutter run --dart-define=ENV=staging
  ///
  /// # Production
  /// flutter run --dart-define=ENV=production
  /// ```
  static String get baseUrl {
    const environment = String.fromEnvironment('ENV', defaultValue: 'dev');

    switch (environment) {
      case 'prod':
      case 'production':
        return _prodBaseUrl;
      case 'staging':
        return _stagingBaseUrl;
      case 'dev':
      case 'development':
      default:
        return _devBaseUrl;
    }
  }

  // ========================================================================
  // TIMEOUT CONFIGURATION
  // ========================================================================

  /// Connection timeout duration (milliseconds)
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout duration (milliseconds)
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout duration (milliseconds)
  static const Duration sendTimeout = Duration(seconds: 30);

  // ========================================================================
  // API ENDPOINTS
  // ========================================================================

  /// API version prefix
  static const String apiVersion = '/api/v1';

  /// Common API endpoints
  static const String authEndpoint = '$apiVersion/auth';
  static const String usersEndpoint = '$apiVersion/users';
  static const String profileEndpoint = '$apiVersion/profile';

  // ========================================================================
  // CACHE CONFIGURATION
  // ========================================================================

  /// Default cache expiration duration
  static const Duration cacheExpiration = Duration(hours: 24);

  // ========================================================================
  // APP METADATA
  // ========================================================================

  /// Application name
  static const String appName = 'HyperFrame';

  /// Application version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// Support email
  static const String supportEmail = 'support@hyperframe.io';
}
