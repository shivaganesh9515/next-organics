import 'package:supabase_flutter/supabase_flutter.dart';

/// User entity representing an authenticated user in the app.
///
/// This is a wrapper around Supabase's User to provide
/// a clean domain entity that doesn't depend on Supabase directly.
class AppUser {
  final String id;
  final String? email;
  final String? phone;
  final String? fullName;
  final String? avatarUrl;
  final DateTime? createdAt;
  final Map<String, dynamic>? metadata;

  const AppUser({
    required this.id,
    this.email,
    this.phone,
    this.fullName,
    this.avatarUrl,
    this.createdAt,
    this.metadata,
  });

  /// Create AppUser from Supabase User
  factory AppUser.fromSupabaseUser(User user) {
    final metadata = user.userMetadata;
    return AppUser(
      id: user.id,
      email: user.email,
      phone: user.phone,
      fullName: metadata?['full_name'] as String?,
      avatarUrl: metadata?['avatar_url'] as String?,
      createdAt: DateTime.tryParse(user.createdAt),
      metadata: metadata,
    );
  }

  /// Check if user has a profile picture
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Get display name (prefer fullName, fallback to email/phone)
  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (email != null && email!.isNotEmpty) return email!.split('@').first;
    if (phone != null && phone!.isNotEmpty) return phone!;
    return 'User';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AppUser(id: $id, name: $displayName)';
}

/// Authentication state for the app
enum AuthStatus {
  /// Initial state, checking for existing session
  initial,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,

  /// Waiting for OTP verification
  awaitingOtp,

  /// Loading state (signing in/out)
  loading,
}

/// Complete auth state including user and status
class AuthStateData {
  final AuthStatus status;
  final AppUser? user;
  final String? error;
  final String? pendingPhone;

  const AuthStateData({
    required this.status,
    this.user,
    this.error,
    this.pendingPhone,
  });

  /// Initial auth state
  factory AuthStateData.initial() => const AuthStateData(
        status: AuthStatus.initial,
      );

  /// Authenticated state
  factory AuthStateData.authenticated(AppUser user) => AuthStateData(
        status: AuthStatus.authenticated,
        user: user,
      );

  /// Unauthenticated state
  factory AuthStateData.unauthenticated() => const AuthStateData(
        status: AuthStatus.unauthenticated,
      );

  /// Loading state
  factory AuthStateData.loading() => const AuthStateData(
        status: AuthStatus.loading,
      );

  /// Awaiting OTP verification
  factory AuthStateData.awaitingOtp(String phone) => AuthStateData(
        status: AuthStatus.awaitingOtp,
        pendingPhone: phone,
      );

  /// Error state
  factory AuthStateData.error(String message) => AuthStateData(
        status: AuthStatus.unauthenticated,
        error: message,
      );

  /// Helper getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAwaitingOtp => status == AuthStatus.awaitingOtp;
  bool get hasError => error != null;

  AuthStateData copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    String? pendingPhone,
  }) {
    return AuthStateData(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      pendingPhone: pendingPhone ?? this.pendingPhone,
    );
  }

  @override
  String toString() => 'AuthStateData(status: $status, user: $user)';
}
