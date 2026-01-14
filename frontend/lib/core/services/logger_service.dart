import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Structured logging service for the application.
///
/// Provides consistent logging format with timestamp and log levels.
/// Only outputs logs in development mode unless explicitly forced.
///
/// Usage:
/// ```dart
/// LoggerService.info('User logged in');
/// LoggerService.error('Failed to fetch products', error, stackTrace);
/// LoggerService.debug('API Response: $response');
/// ```
class LoggerService {
  // Allow instantiation for DI
  const LoggerService();

  static const String _tag = 'NextOrganics';

  /// Log informational messages
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag: tag);
  }

  /// Log warning messages
  static void warning(String message, {String? tag}) {
    _log('WARN', message, tag: tag);
  }

  /// Log error messages with optional error object and stack trace
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log('ERROR', message, error: error, stackTrace: stackTrace);
  }

  /// Log debug messages (only in dev mode)
  static void debug(String message, {String? tag}) {
    if (AppConfig.enableLogging) {
      _log('DEBUG', message, tag: tag);
    }
  }

  /// Log API request/response for debugging
  static void api(String method, String endpoint,
      {dynamic body, dynamic response}) {
    if (!AppConfig.enableLogging) return;

    final buffer = StringBuffer()..writeln('[$method] $endpoint');

    if (body != null) {
      buffer.writeln('Request: $body');
    }
    if (response != null) {
      buffer.writeln('Response: $response');
    }

    _log('API', buffer.toString());
  }

  // Instance methods forwarding to static methods for DI support
  void d(String message, {String? tag}) => debug(message, tag: tag);
  void i(String message, {String? tag}) => info(message, tag: tag);
  void w(String message, {String? tag}) => warning(message, tag: tag);
  void e(String message, [Object? err, StackTrace? stack]) =>
      LoggerService.error(message, err, stack);

  static void _log(
    String level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip logging in production for non-error logs
    if (!kDebugMode && level != 'ERROR') return;

    final timestamp = DateTime.now().toIso8601String();
    final logTag = tag ?? _tag;
    final formattedMessage = '[$timestamp] [$level] [$logTag] $message';

    if (kDebugMode) {
      developer.log(
        formattedMessage,
        name: logTag,
        error: error,
        stackTrace: stackTrace,
        level: _getLevelValue(level),
      );
    }

    // In production, we could send errors to crash reporting service
    if (level == 'ERROR' && !kDebugMode) {
      // TODO: Send to crash reporting (Firebase Crashlytics, Sentry, etc.)
      // CrashReporting.recordError(error, stackTrace);
    }
  }

  static int _getLevelValue(String level) {
    switch (level) {
      case 'DEBUG':
        return 500;
      case 'INFO':
        return 800;
      case 'WARN':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 800;
    }
  }
}
