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
import '../widgets/main_scaffold.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/address/presentation/screens/address_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
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
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      builder: (context, state) => const MainScaffold(
        currentIndex: 1,
        child: CategoryScreen(categoryId: 'all', categoryName: 'All Categories'),
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
  ],
);
