/// Constants for SharedPreferences keys
class PreferenceKeys {
  // Private constructor to prevent instantiation
  PreferenceKeys._();

  // App Configuration
  static const String appTheme = 'app_theme';
  static const String appLanguage = 'app_language';
  static const String isFirstLaunch = 'is_first_launch';

  // User Preferences
  static const String userName = 'user_name';
  static const String userEmail = 'user_email';
  static const String userId = 'user_id';

  // Todo Settings
  static const String todoSortOrder = 'todo_sort_order';
  static const String showCompletedTodos = 'show_completed_todos';
  static const String todosPerPage = 'todos_per_page';
  static const String lastRefreshTime = 'last_refresh_time';

  // Cache Settings
  static const String cacheExpiration = 'cache_expiration';
  static const String enableOfflineMode = 'enable_offline_mode';

  // UI Settings
  static const String enableAnimations = 'enable_animations';
  static const String enableNotifications = 'enable_notifications';
  static const String listViewType = 'list_view_type'; // grid or list

  // API Settings
  static const String apiBaseUrl = 'api_base_url';
  static const String apiTimeout = 'api_timeout';

  // Debug Settings
  static const String enableDebugMode = 'enable_debug_mode';
  static const String enableLogging = 'enable_logging';
}
