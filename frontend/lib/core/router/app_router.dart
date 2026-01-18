import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/category_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/favourites/presentation/screens/favourites_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/vendor_profile_screen.dart';
import '../widgets/main_scaffold.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/order_success_screen.dart';
import '../../features/address/presentation/screens/address_screen.dart';
import '../theme/app_colors.dart';

/// Routes that don't require authentication
const _publicRoutes = ['/onboarding', '/login', '/otp'];

/// Create app router with optional auth state for redirection
GoRouter createAppRouter({bool isAuthenticated = false}) {
  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isPublicRoute = _publicRoutes.contains(state.matchedLocation);

      if (!isAuthenticated) {
        // If not authenticated, block access to private routes
        if (!isPublicRoute) {
          return '/login';
        }
      } else {
        // If authenticated, block access to auth routes (except onboarding maybe?)
        // Generally we skip onboarding if auth'd
        if (isPublicRoute) {
          return '/home';
        }
      }
      return null;
    },
    routes: [
      // --- Auth Routes ---
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OtpScreen(phoneNumber: phoneNumber);
        },
      ),

      // --- Main App Routes ---
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const MainScaffold(
          currentIndex: 1,
          child:
              CategoryScreen(categoryId: 'all', categoryName: 'All Categories'),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return ProductDetailsPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/category/:id',
        name: 'category',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final name = state.extra as String? ?? 'Category';
          return MainScaffold(
            currentIndex: 1,
            child: CategoryScreen(categoryId: id, categoryName: name),
          );
        },
      ),
      GoRoute(
        path: '/vendor/:id',
        name: 'vendor',
        builder: (context, state) {
          final vendorId = state.pathParameters['id']!;
          return VendorProfileScreen(vendorId: vendorId);
        },
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const MainScaffold(
          currentIndex: 3,
          child: CartPage(),
        ),
      ),
      GoRoute(
        path: '/favourites',
        name: 'favourites',
        builder: (context, state) => const MainScaffold(
          currentIndex: 2,
          child: FavouritesPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/addresses',
        name: 'addresses',
        builder: (context, state) => const AddressScreen(),
      ),

      // --- Checkout Flow ---
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Checkout'),
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const _PlaceholderScreen(title: 'Payment'),
      ),
      GoRoute(
        path: '/order-success',
        name: 'orderSuccess',
        builder: (context, state) => const OrderSuccessScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page you\'re looking for doesn\'t exist.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Legacy router for backward compatibility
final router = createAppRouter();

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: AppColors.warning),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
