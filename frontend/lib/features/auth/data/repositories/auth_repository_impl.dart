import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart'
    show
        SupabaseClient,
        Session,
        User,
        AuthState,
        AuthChangeEvent,
        OtpType,
        OAuthProvider,
        AuthException;

import '../../../../core/exceptions/app_exception.dart';
import '../../../../core/services/logger_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

/// Supabase implementation of the AuthRepository.
///
/// Handles all authentication operations using Supabase Auth,
/// including phone OTP, Google OAuth, and session management.
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;
  final SecureStorageService _storage;

  final _authStateController = StreamController<AuthStateData>.broadcast();
  AuthStateData _currentState = AuthStateData.initial();

  AuthRepositoryImpl({
    required SupabaseClient client,
    required SecureStorageService storage,
  })  : _client = client,
        _storage = storage {
    // Listen to Supabase auth state changes
    _client.auth.onAuthStateChange.listen((event) {
      _handleAuthStateChange(event);
    });
  }

  @override
  Stream<AuthStateData> get authStateChanges => _authStateController.stream;

  @override
  AuthStateData get currentState => _currentState;

  @override
  AppUser? get currentUser => _currentState.user;

  @override
  bool get isAuthenticated => _currentState.isAuthenticated;

  void _updateState(AuthStateData newState) {
    _currentState = newState;
    _authStateController.add(newState);
  }

  void _handleAuthStateChange(AuthState event) {
    LoggerService.info('Auth state changed: ${event.event}');

    switch (event.event) {
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.tokenRefreshed:
        if (event.session?.user != null) {
          final user = AppUser.fromSupabaseUser(event.session!.user);
          _updateState(AuthStateData.authenticated(user));
          _saveSession(event.session!);
        }
        break;
      case AuthChangeEvent.signedOut:
        _updateState(AuthStateData.unauthenticated());
        _storage.clearSession();
        break;
      case AuthChangeEvent.userUpdated:
        if (event.session?.user != null) {
          final user = AppUser.fromSupabaseUser(event.session!.user);
          _updateState(AuthStateData.authenticated(user));
        }
        break;
      default:
        break;
    }
  }

  Future<void> _saveSession(Session session) async {
    try {
      await _storage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
        userId: session.user.id,
      );
    } catch (e) {
      LoggerService.error('Failed to save session', e);
    }
  }

  @override
  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      _updateState(AuthStateData.loading());

      // Format phone number (ensure it has country code)
      final formattedPhone =
          phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';

      await _client.auth.signInWithOtp(
        phone: formattedPhone,
      );

      _updateState(AuthStateData.awaitingOtp(formattedPhone));
      LoggerService.info('OTP sent to $formattedPhone');

      return formattedPhone;
    } on AuthException catch (e) {
      LoggerService.error('Phone sign in failed', e);
      _updateState(AuthStateData.error(e.message));
      throw AppAuthException(message: e.message);
    } catch (e, st) {
      LoggerService.error('Unexpected error during phone sign in', e, st);
      _updateState(
          AuthStateData.error('Failed to send OTP. Please try again.'));
      throw const ServerException(
        message: 'Failed to send OTP. Please try again.',
      );
    }
  }

  @override
  Future<AppUser> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      _updateState(AuthStateData.loading());

      final response = await _client.auth.verifyOTP(
        phone: phoneNumber,
        token: otpCode,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw AppAuthException.invalidCredentials();
      }

      final user = AppUser.fromSupabaseUser(response.user!);
      _updateState(AuthStateData.authenticated(user));
      LoggerService.info('OTP verified successfully for user: ${user.id}');

      return user;
    } on AuthException catch (e) {
      LoggerService.error('OTP verification failed', e);
      _updateState(AuthStateData.error(e.message));
      rethrow;
    } catch (e, st) {
      LoggerService.error('Unexpected error during OTP verification', e, st);
      _updateState(AuthStateData.error('Invalid OTP. Please try again.'));
      throw AppAuthException.invalidCredentials();
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      _updateState(AuthStateData.loading());

      // Note: OAuth requires additional setup:
      // 1. Configure Google OAuth in Supabase dashboard
      // 2. Set up deep links for redirect handling
      // For now, we throw an error indicating this is not yet configured
      throw const AppAuthException(
        message:
            'Google sign in is not yet configured. Please use phone login.',
        code: 'NOT_CONFIGURED',
      );

      // TODO: When ready, implement OAuth:
      // await _client.auth.signInWithOAuth(
      //   OAuthProvider.google,
      //   redirectTo: 'io.supabase.nextorganics://login-callback/',
      // );
    } catch (e, st) {
      LoggerService.error('Google sign in failed', e, st);
      _updateState(AuthStateData.error('Google sign in is not available'));
      if (e is AppAuthException) rethrow;
      throw const AppAuthException(message: 'Google sign in failed');
    }
  }

  @override
  Future<AppUser> signInWithApple() async {
    try {
      _updateState(AuthStateData.loading());

      // Note: Apple OAuth requires additional setup:
      // 1. Configure Apple OAuth in Supabase dashboard
      // 2. Set up deep links for redirect handling
      // 3. Apple Developer account configuration
      throw const AppAuthException(
        message: 'Apple sign in is not yet configured. Please use phone login.',
        code: 'NOT_CONFIGURED',
      );

      // TODO: When ready, implement OAuth:
      // await _client.auth.signInWithOAuth(
      //   OAuthProvider.apple,
      //   redirectTo: 'io.supabase.nextorganics://login-callback/',
      // );
    } catch (e, st) {
      LoggerService.error('Apple sign in failed', e, st);
      _updateState(AuthStateData.error('Apple sign in is not available'));
      if (e is AppAuthException) rethrow;
      throw const AppAuthException(message: 'Apple sign in failed');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      _updateState(AuthStateData.loading());
      await _client.auth.signOut();
      await _storage.clearSession();
      _updateState(AuthStateData.unauthenticated());
      LoggerService.info('User signed out');
    } catch (e, st) {
      LoggerService.error('Sign out failed', e, st);
      // Force unauthenticated state even on error
      _updateState(AuthStateData.unauthenticated());
      await _storage.clearSession();
    }
  }

  @override
  Future<void> refreshSession() async {
    try {
      final response = await _client.auth.refreshSession();
      if (response.session != null) {
        await _saveSession(response.session!);
        LoggerService.info('Session refreshed');
      }
    } catch (e, st) {
      LoggerService.error('Session refresh failed', e, st);
      throw AppAuthException.sessionExpired();
    }
  }

  @override
  Future<AuthStateData> checkSession() async {
    try {
      final session = _client.auth.currentSession;

      if (session != null) {
        final user = AppUser.fromSupabaseUser(session.user);
        final state = AuthStateData.authenticated(user);
        _updateState(state);
        return state;
      }

      // Try to restore session from storage
      final storedToken = await _storage.getAccessToken();
      if (storedToken != null) {
        try {
          await refreshSession();
          return _currentState;
        } catch (_) {
          // Token expired or invalid
        }
      }

      final state = AuthStateData.unauthenticated();
      _updateState(state);
      return state;
    } catch (e, st) {
      LoggerService.error('Session check failed', e, st);
      final state = AuthStateData.unauthenticated();
      _updateState(state);
      return state;
    }
  }

  /// Clean up resources
  void dispose() {
    _authStateController.close();
  }
}
