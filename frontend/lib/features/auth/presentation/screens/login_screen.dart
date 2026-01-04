import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animations/animated_scale_button.dart';
import '../../../../core/widgets/animations/fade_in_slide.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid mobile number')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1)); // Mock backend delay

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Image Section
            FadeInSlide(
              delay: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=800&q=80'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Next Organics',
                          style: AppTypography.labelMedium.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Fresh Groceries\nDelivered Daily',
                        style: AppTypography.headingLarge.copyWith(
                          color: Colors.white,
                          fontSize: 32,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // Phone Input
                  FadeInSlide(
                    delay: 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Text('+91', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(width: 12),
                          Container(width: 1, height: 24, color: Colors.grey.shade300),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mobile Number',
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
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
                      onTap: _onLogin,
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
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
                            style: AppTypography.labelSmall.copyWith(color: AppColors.textHint),
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
                        _SocialButton(icon: Icons.g_mobiledata, label: 'Google', onTap: () {}),
                        const SizedBox(width: 16),
                        _SocialButton(icon: Icons.apple, label: 'Apple', onTap: () {}),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  FadeInSlide(
                    delay: 0.4,
                    child: Center(
                      child: Text(
                        'By continuing, you agree to our Terms & Privacy Policy',
                        style: AppTypography.labelSmall.copyWith(color: AppColors.textHint),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  const _SocialButton({required this.icon, required this.label, required this.onTap});

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
              style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
