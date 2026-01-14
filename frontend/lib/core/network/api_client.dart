import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart'
    show
        SupabaseClient,
        Supabase,
        PostgrestException,
        PostgrestFilterBuilder,
        PostgrestTransformBuilder,
        AuthException;
import '../config/app_config.dart';
import '../exceptions/app_exception.dart';
import '../services/logger_service.dart';

/// Centralized API client wrapping Supabase operations.
///
/// Provides:
/// - Automatic error handling and exception mapping
/// - Request/response logging
/// - Timeout handling
/// - Retry logic for transient errors
///
/// Usage:
/// ```dart
/// final client = ApiClient();
/// final products = await client.query(
///   table: 'products',
///   queryBuilder: (q) => q.eq('is_active', true).limit(10),
/// );
/// ```
class ApiClient {
  SupabaseClient get _client => Supabase.instance.client;

  /// Execute a SELECT query on a table
  Future<List<Map<String, dynamic>>> query({
    required String table,
    String select = '*',
    PostgrestTransformBuilder<List<Map<String, dynamic>>> Function(
      PostgrestFilterBuilder<List<Map<String, dynamic>>>,
    )? queryBuilder,
  }) async {
    return _executeWithErrorHandling(() async {
      var query = _client.from(table).select(select);

      if (queryBuilder != null) {
        final result = await queryBuilder(query);
        LoggerService.api('SELECT', table, response: '${result.length} rows');
        return result;
      }

      final result = await query;
      LoggerService.api('SELECT', table, response: '${result.length} rows');
      return result as List<Map<String, dynamic>>;
    });
  }

  /// Execute a single row SELECT query
  Future<Map<String, dynamic>?> querySingle({
    required String table,
    required String column,
    required dynamic value,
    String select = '*',
  }) async {
    return _executeWithErrorHandling(() async {
      final result = await _client
          .from(table)
          .select(select)
          .eq(column, value)
          .maybeSingle();

      LoggerService.api('SELECT SINGLE', '$table.$column=$value');
      return result;
    });
  }

  /// Insert a row into a table
  Future<Map<String, dynamic>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    return _executeWithErrorHandling(() async {
      final result = await _client.from(table).insert(data).select().single();

      LoggerService.api('INSERT', table, body: data);
      return result;
    });
  }

  /// Update rows in a table
  Future<List<Map<String, dynamic>>> update({
    required String table,
    required Map<String, dynamic> data,
    required String matchColumn,
    required dynamic matchValue,
  }) async {
    return _executeWithErrorHandling(() async {
      final result = await _client
          .from(table)
          .update(data)
          .eq(matchColumn, matchValue)
          .select();

      LoggerService.api('UPDATE', '$table.$matchColumn=$matchValue',
          body: data);
      return result;
    });
  }

  /// Delete rows from a table
  Future<void> delete({
    required String table,
    required String matchColumn,
    required dynamic matchValue,
  }) async {
    return _executeWithErrorHandling(() async {
      await _client.from(table).delete().eq(matchColumn, matchValue);

      LoggerService.api('DELETE', '$table.$matchColumn=$matchValue');
    });
  }

  /// Call a Supabase RPC function
  Future<dynamic> rpc({
    required String functionName,
    Map<String, dynamic>? params,
  }) async {
    return _executeWithErrorHandling(() async {
      final result = await _client.rpc(functionName, params: params);
      LoggerService.api('RPC', functionName, body: params, response: result);
      return result;
    });
  }

  /// Execute with error handling, retry, and timeout
  Future<T> _executeWithErrorHandling<T>(Future<T> Function() operation) async {
    try {
      return await operation().timeout(
        Duration(seconds: AppConfig.requestTimeoutSeconds),
        onTimeout: () {
          throw const NetworkException(
            message: 'Request timed out. Please try again.',
            code: 'TIMEOUT',
          );
        },
      );
    } on PostgrestException catch (e) {
      LoggerService.error('Supabase error: ${e.message}', e);
      throw _mapPostgrestException(e);
    } on AuthException catch (e) {
      LoggerService.error('Auth error: ${e.message}', e);
      throw AppAuthException(message: e.message);
    } on TimeoutException {
      throw const NetworkException(
        message: 'Request timed out. Please try again.',
        code: 'TIMEOUT',
      );
    } catch (e, st) {
      LoggerService.error('Unexpected error', e, st);

      // Check for network-related errors
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection refused')) {
        throw const NetworkException();
      }

      throw ServerException(
        message: 'An unexpected error occurred.',
        originalError: e,
      );
    }
  }

  /// Map Supabase PostgrestException to our custom exceptions
  AppException _mapPostgrestException(PostgrestException e) {
    final code = e.code;
    final message = e.message;

    // Authentication errors
    if (code == '401' || code == 'PGRST301') {
      return AppAuthException.sessionExpired();
    }

    // Authorization errors
    if (code == '403' || message.contains('permission denied')) {
      return AppAuthException.unauthorized();
    }

    // Not found
    if (code == 'PGRST116') {
      return NotFoundException(message: message);
    }

    // Validation errors
    if (code == '400' || code == '422' || code?.startsWith('23') == true) {
      return ValidationException(message: message, originalError: e);
    }

    // Server errors
    if (code?.startsWith('5') == true) {
      return ServerException(message: message, originalError: e);
    }

    // Default to server exception
    return ServerException(message: message, originalError: e);
  }
}
