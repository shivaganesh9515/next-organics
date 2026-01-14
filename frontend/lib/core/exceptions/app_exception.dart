/// Custom exception classes for structured error handling.
///
/// These exceptions provide meaningful error types that can be caught
/// and handled appropriately in the UI layer.
library;

/// Base exception class for all app-specific exceptions.
sealed class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Network-related exceptions (no internet, timeout, etc.)
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
    super.originalError,
  });
}

/// Authentication exceptions (invalid credentials, session expired, etc.)
class AppAuthException extends AppException {
  const AppAuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.originalError,
  });

  /// Session has expired, user needs to re-authenticate
  factory AppAuthException.sessionExpired() => const AppAuthException(
        message: 'Your session has expired. Please login again.',
        code: 'SESSION_EXPIRED',
      );

  /// Invalid credentials provided
  factory AppAuthException.invalidCredentials() => const AppAuthException(
        message: 'Invalid phone number or OTP.',
        code: 'INVALID_CREDENTIALS',
      );

  /// User not authorized to access resource
  factory AppAuthException.unauthorized() => const AppAuthException(
        message: 'You are not authorized to perform this action.',
        code: 'UNAUTHORIZED',
      );
}

/// Server-side exceptions (500 errors, maintenance, etc.)
class ServerException extends AppException {
  const ServerException({
    super.message = 'Something went wrong. Please try again later.',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });

  /// Server is under maintenance
  factory ServerException.maintenance() => const ServerException(
        message: 'Server is under maintenance. Please try again later.',
        code: 'MAINTENANCE',
      );
}

/// Validation exceptions (invalid input, bad request, etc.)
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    this.fieldErrors,
  });

  /// Get error message for a specific field
  String? getFieldError(String field) => fieldErrors?[field];
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.code = 'NOT_FOUND',
    super.originalError,
  });

  factory NotFoundException.product() => const NotFoundException(
        message: 'Product not found.',
        code: 'PRODUCT_NOT_FOUND',
      );

  factory NotFoundException.order() => const NotFoundException(
        message: 'Order not found.',
        code: 'ORDER_NOT_FOUND',
      );
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException({
    super.message = 'Failed to access local cache.',
    super.code = 'CACHE_ERROR',
    super.originalError,
  });
}
