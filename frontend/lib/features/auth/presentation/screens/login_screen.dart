import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animations/animated_scale_button.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart';
import '../../domain/entities/auth_state.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  // Test Connection Debug Function
  Future<void> _testConnection() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.from('products').select().limit(5);
      final count = (response as List).length;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('✅ Connection Success! Found $count products (limit 5).'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Connection Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // ============================================
  // DEMO MODE: Skip OTP for demo purposes
  // Set to false to enable real OTP authentication
  // ============================================
  static const bool _demoMode = true;

  void _onLogin() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
      return;
    }

    // DEMO MODE: Skip OTP and go directly to home
    if (_demoMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demo Mode: Logging in...'),
          duration: Duration(seconds: 1),
        ),
      );

      // Update auth state correctly instead of just navigating
      ref.read(authNotifierProvider.notifier).loginAsDemoUser();

      // Navigation will be handled by the listener in build() or Router
      return;
    }

    // PRODUCTION MODE: Use real OTP authentication
    // await ref.read(authNotifierProvider.notifier).signInWithPhone(
    //       _phoneController.text,
    //     );
  }

  void _onGoogleLogin() async {
    // DEMO MODE: Skip and go to home
    if (_demoMode) {
      context.go('/home');
      return;
    }
    // await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  void _onAppleLogin() async {
    // DEMO MODE: Skip and go to home
    if (_demoMode) {
      context.go('/home');
      return;
    }
    // await ref.read(authNotifierProvider.notifier).signInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    // Listen for state changes to navigate (disabled in demo mode)
    if (!_demoMode) {
      ref.listen<AuthStateData>(authNotifierProvider, (previous, next) {
        if (next.isAuthenticated) {
          context.go('/home');
        } else if (next.isAwaitingOtp && next.pendingPhone != null) {
          context.push('/otp', extra: next.pendingPhone);
        } else if (next.hasError && next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red.shade600,
            ),
          );
          ref.read(authNotifierProvider.notifier).clearError();
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section with Logo
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.background,
                // Soft gradient background
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFECFCCB), // AppColors.primarySurface
                    AppColors.background,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInSlide(
                    delay: 0,
                    child: Hero(
                      tag: 'app_logo',
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 180,
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeInSlide(
                    delay: 0.1,
                    child: Text(
                      'Fresh Groceries\nDelivered Daily',
                      style: AppTypography.headingLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Login Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInSlide(
                    delay: 0.1,
                    child: Text(
                      'Get Started',
                      style: AppTypography.headingMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeInSlide(
                    delay: 0.15,
                    child: Text(
                      'Enter your mobile number to login or signup',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Phone Input
                  FadeInSlide(
                    delay: 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Text('+91',
                              style: AppTypography.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 12),
                          Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: AppTypography.bodyLarge
                                  .copyWith(fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile Number',
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              enabled: !isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  FadeInSlide(
                    delay: 0.25,
                    child: AnimatedScaleButton(
                      onTap: isLoading ? () {} : _onLogin,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                'Continue',
                                style: AppTypography.labelLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Social Login Divider
                  FadeInSlide(
                    delay: 0.3,
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: AppTypography.labelSmall
                                .copyWith(color: AppColors.textHint),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade200)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Social Buttons
                  FadeInSlide(
                    delay: 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onTap: isLoading ? () {} : _onGoogleLogin,
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          icon: Icons.apple,
                          label: 'Apple',
                          onTap: isLoading ? () {} : _onAppleLogin,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  FadeInSlide(
                    delay: 0.4,
                    child: Center(
                      child: Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        style: AppTypography.labelSmall
                            .copyWith(color: AppColors.textHint),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Debug Button
            TextButton.icon(
              onPressed: _testConnection,
              icon: const Icon(Icons.bug_report, size: 16),
              label: const Text('Test Supabase Connection'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedScaleButton(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.labelMedium
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
