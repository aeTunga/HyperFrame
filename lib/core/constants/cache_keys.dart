/// Type-safe Cache Keys
///
/// Centralized cache key management to prevent typos and ensure consistency.
/// Uses class-based approach for better organization and IDE autocomplete.
class CacheKeys {
  CacheKeys._(); // Private constructor to prevent instantiation

  // ========================================================================
  // AUTHENTICATION KEYS
  // ========================================================================

  /// JWT access token
  static const String accessToken = 'access_token';

  /// JWT refresh token
  static const String refreshToken = 'refresh_token';

  /// User ID
  static const String userId = 'user_id';

  /// User email
  static const String userEmail = 'user_email';

  /// User logged in status
  static const String isLoggedIn = 'is_logged_in';

  // ========================================================================
  // THEME KEYS
  // ========================================================================

  /// Theme mode preference (light/dark/system)
  /// Values: 'light', 'dark', 'system'
  static const String themeMode = 'theme_mode';

  /// Last selected theme mode
  static const String lastThemeMode = 'last_theme_mode';

  // ========================================================================
  // APP PREFERENCES
  // ========================================================================

  /// First launch flag
  static const String isFirstLaunch = 'is_first_launch';

  /// Onboarding completed flag
  static const String onboardingCompleted = 'onboarding_completed';

  /// Language preference (locale code)
  static const String languageCode = 'language_code';

  /// Notification enabled flag
  static const String notificationsEnabled = 'notifications_enabled';

  /// HyperConsole favorite routes (JSON array of route strings)
  static const String hyperConsoleFavoriteRoutes =
      'hyper_console_favorite_routes';

  // ========================================================================
  // CACHE METADATA
  // ========================================================================

  /// Last cache update timestamp
  static const String lastCacheUpdate = 'last_cache_update';

  /// Cache version (for migration purposes)
  static const String cacheVersion = 'cache_version';

  // ========================================================================
  // FEATURE FLAGS
  // ========================================================================

  /// DevicePreview enabled
  static const String devicePreviewEnabled = 'device_preview_enabled';

  /// Debug mode enabled
  static const String debugModeEnabled = 'debug_mode_enabled';

  // ========================================================================
  // USER DATA CACHE
  // ========================================================================

  /// Cached user profile JSON
  static const String userProfile = 'user_profile';

  /// Cached user settings JSON
  static const String userSettings = 'user_settings';
}
