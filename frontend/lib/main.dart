import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/providers/auth_provider.dart';

import 'core/config/app_config.dart';
import 'core/services/logger_service.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  // Change to Environment.dev for development builds
  AppConfig.initialize(Environment.prod);

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );
    LoggerService.info('Supabase initialized successfully');
  } catch (e, st) {
    LoggerService.error('Supabase initialization failed', e, st);
    // Continue anyway - the app will show appropriate error states
  }

  runApp(
    const ProviderScope(
      child: NextOrganicsApp(),
    ),
  );
}

// Router provider to handle auth redirects dynamically
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return createAppRouter(isAuthenticated: authState.isAuthenticated);
});

/// Root application widget
class NextOrganicsApp extends ConsumerWidget {
  const NextOrganicsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        // Global error boundary
        ErrorWidget.builder = (FlutterErrorDetails details) {
          LoggerService.error(
            'Widget error: ${details.exception}',
            details.exception,
            details.stack,
          );
          return _ErrorWidget(details: details);
        };
        return child ?? const SizedBox.shrink();
      },
    );
  }
}

/// Custom error widget shown when a widget throws an error
class _ErrorWidget extends StatelessWidget {
  final FlutterErrorDetails details;

  const _ErrorWidget({required this.details});

  @override
  Widget build(BuildContext context) {
    final isDev = AppConfig.isDev;

    return Container(
      color: Colors.red.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade700,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          if (isDev) ...[
            const SizedBox(height: 8),
            Text(
              details.exception.toString(),
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
