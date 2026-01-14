import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/services/logger_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';

/// Provider for the auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(client: client, storage: storage);
});

/// Provider for auth state stream
final authStateProvider = StreamProvider<AuthStateData>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Provider for current user
final authUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for checking authentication status
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.isAuthenticated,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Notifier for auth actions (login, logout, etc.)
class AuthNotifier extends StateNotifier<AuthStateData> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthStateData.initial()) {
    _init();
  }

  void _init() {
    // Listen to auth state changes from repository
    _repository.authStateChanges.listen((newState) {
      state = newState;
    });

    // Check for existing session
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final authState = await _repository.checkSession();
      state = authState;
    } catch (e) {
      state = AuthStateData.unauthenticated();
    }
  }

  /// Request OTP to be sent to phone number
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      state = AuthStateData.loading();
      final phone = await _repository.signInWithPhone(phoneNumber);
      state = AuthStateData.awaitingOtp(phone);
    } catch (e) {
      LoggerService.error('Phone sign in failed', e);
      state = AuthStateData.error(
        e.toString().contains('message:')
            ? e.toString().split('message:').last.trim()
            : 'Failed to send OTP',
      );
    }
  }

  /// Verify OTP code
  Future<bool> verifyOtp(String otpCode) async {
    if (state.pendingPhone == null) {
      state = AuthStateData.error('No pending phone verification');
      return false;
    }

    try {
      state = AuthStateData.loading();
      final user = await _repository.verifyOtp(
        phoneNumber: state.pendingPhone!,
        otpCode: otpCode,
      );
      state = AuthStateData.authenticated(user);
      return true;
    } catch (e) {
      LoggerService.error('OTP verification failed', e);
      state = AuthStateData.error('Invalid OTP. Please try again.');
      return false;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      state = AuthStateData.loading();
      final user = await _repository.signInWithGoogle();
      state = AuthStateData.authenticated(user);
    } catch (e) {
      LoggerService.error('Google sign in failed', e);
      state = AuthStateData.error('Google sign in failed');
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      state = AuthStateData.loading();
      final user = await _repository.signInWithApple();
      state = AuthStateData.authenticated(user);
    } catch (e) {
      LoggerService.error('Apple sign in failed', e);
      state = AuthStateData.error('Apple sign in failed');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      state = AuthStateData.loading();
      await _repository.signOut();
      state = AuthStateData.unauthenticated();
    } catch (e) {
      LoggerService.error('Sign out failed', e);
      // Force unauthenticated state
      state = AuthStateData.unauthenticated();
    }
  }

  /// Demo Login
  void loginAsDemoUser() {
    state = AuthStateData.loading();
    // Simulate network delay
    Future.delayed(const Duration(milliseconds: 500), () {
      state = AuthStateData.authenticated(
        const AppUser(
          id: 'demo-user-id',
          fullName: 'Demo User',
          phone: '+919876543210',
          email: 'demo@nextorganics.com',
        ),
      );
    });
  }

  /// Clear any error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(error: null);
    }
  }

  /// Reset to unauthenticated (for back navigation from OTP)
  void resetToUnauthenticated() {
    state = AuthStateData.unauthenticated();
  }
}

/// StateNotifier provider for auth actions
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
