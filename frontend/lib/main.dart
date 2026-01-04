import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/providers/theme_provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your actual Supabase keys
  // try {
  //   await Supabase.initialize(
  //     url: 'https://ubyucfzaucuxsfdaddkv.supabase.co',
  //     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVieXVjZnphdWN1eHNmZGFkZGt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU3ODM1OTcsImV4cCI6MjA4MTM1OTU5N30.EWhGuusPMKycC8zyFB729V0NDNrtxjguWEvLf_DmLt0',
  //   );
  // } catch (e) {
  //   debugPrint('Supabase initialization failed: $e');
  // }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Next Organics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
