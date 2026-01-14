/// Environment configuration for the Next Organics app.
///
/// This provides a centralized way to manage environment-specific
/// configurations like API URLs and keys.
library;

/// Available application environments
enum Environment { dev, prod }

/// Centralized application configuration.
///
/// Usage:
/// ```dart
/// // In main.dart before runApp
/// AppConfig.initialize(Environment.prod);
///
/// // Access anywhere
/// final url = AppConfig.supabaseUrl;
/// ```
class AppConfig {
  AppConfig._();

  static Environment _environment = Environment.prod;
  static bool _initialized = false;

  /// Initialize the app configuration with the specified environment.
  /// Must be called before accessing any configuration values.
  static void initialize(Environment env) {
    _environment = env;
    _initialized = true;
  }

  /// Current environment
  static Environment get environment {
    _ensureInitialized();
    return _environment;
  }

  /// Whether we're running in development mode
  static bool get isDev => _environment == Environment.dev;

  /// Whether we're running in production mode
  static bool get isProd => _environment == Environment.prod;

  /// Supabase project URL
  static String get supabaseUrl {
    _ensureInitialized();
    switch (_environment) {
      case Environment.dev:
        // Use same URL for dev (Supabase handles environments via keys/RLS)
        return 'https://ubyucfzaucuxsfdaddkv.supabase.co';
      case Environment.prod:
        return 'https://ubyucfzaucuxsfdaddkv.supabase.co';
    }
  }

  /// Supabase anonymous key (public, safe to expose)
  static String get supabaseAnonKey {
    _ensureInitialized();
    switch (_environment) {
      case Environment.dev:
        return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVieXVjZnphdWN1eHNmZGFkZGt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3ODM1OTcsImV4cCI6MjA4MTM1OTU5N30.EWhGuusPMKycC8zyFB729V0NDNrtxjguWEvLf_DmLt0';
      case Environment.prod:
        return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVieXVjZnphdWN1eHNmZGFkZGt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3ODM1OTcsImV4cCI6MjA4MTM1OTU5N30.EWhGuusPMKycC8zyFB729V0NDNrtxjguWEvLf_DmLt0';
    }
  }

  /// App name displayed in UI
  static String get appName => 'Next Organics';

  /// API request timeout in seconds
  static int get requestTimeoutSeconds => isDev ? 30 : 15;

  /// Enable verbose logging
  static bool get enableLogging => isDev;

  static void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'AppConfig not initialized. Call AppConfig.initialize() in main().',
      );
    }
  }
}
