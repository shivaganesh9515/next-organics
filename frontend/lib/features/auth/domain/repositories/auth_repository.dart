import '../entities/auth_state.dart';

/// Abstract repository interface for authentication operations.
///
/// This defines the contract that any auth implementation must follow,
/// allowing for easy testing with mocks and potential provider switches.
abstract class AuthRepository {
  /// Stream of auth state changes
  Stream<AuthStateData> get authStateChanges;

  /// Get current auth state
  AuthStateData get currentState;

  /// Get current user if authenticated
  AppUser? get currentUser;

  /// Check if user is currently authenticated
  bool get isAuthenticated;

  /// Sign in with phone number (sends OTP)
  /// Returns the phone number that OTP was sent to
  Future<String> signInWithPhone(String phoneNumber);

  /// Verify OTP code for phone sign in
  Future<AppUser> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  });

  /// Sign in with Google OAuth
  Future<AppUser> signInWithGoogle();

  /// Sign in with Apple OAuth
  Future<AppUser> signInWithApple();

  /// Sign out the current user
  Future<void> signOut();

  /// Refresh the current session
  Future<void> refreshSession();

  /// Check and restore session from storage
  Future<AuthStateData> checkSession();
}
