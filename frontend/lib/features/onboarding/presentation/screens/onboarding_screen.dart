import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = const [
    OnboardingPage(
      imagePath: 'assets/images/logo.png',
      title: 'Pure Organics. Direct from Farms.',
      description:
          'Know exactly where your food comes from. Every product traced back to certified organic farms.',
    ),
    OnboardingPage(
      icon: '✨',
      title: 'Premium Quality Guaranteed',
      description:
          'We partner only with verified organic farms to bring you the freshest, chemical-free produce.',
    ),
    OnboardingPage(
      icon: '🚀',
      title: 'Farm to Table in Hours',
      description:
          'Same-day delivery from local farms. Fresher than supermarkets, better for your family.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(
                    'Skip',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _PageContent(page: _pages[index]);
                },
              ),
            ),
            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.textHintDark
                            : AppColors.textHint),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Next/Get Started Button
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/login');
                    }
                  },
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final OnboardingPage page;

  const _PageContent({required this.page});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or Image
          if (page.imagePath != null)
            Image.asset(
              page.imagePath!,
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            )
          else
            Text(
              page.icon ?? '',
              style: const TextStyle(fontSize: 120),
            ),
          const SizedBox(height: 48),
          // Title
          Text(
            page.title,
            style: AppTypography.displaySmall.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            page.description,
            style: AppTypography.bodyLarge.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String? icon;
  final String? imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    this.icon,
    this.imagePath,
    required this.title,
    required this.description,
  }) : assert(icon != null || imagePath != null);
}
