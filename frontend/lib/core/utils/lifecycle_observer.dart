import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/performance_providers.dart' as perf;

/// Mixin to handle app lifecycle state changes
/// Add this to your main app widget to track background/foreground state
mixin AppLifecycleObserver<T extends ConsumerStatefulWidget> on ConsumerState<T>
    implements WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(perf.appLifecycleProvider.notifier).state =
            perf.AppLifecycleState.resumed;
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        ref.read(perf.appLifecycleProvider.notifier).state =
            perf.AppLifecycleState.paused;
        onAppPaused();
        break;
      case AppLifecycleState.inactive:
        ref.read(perf.appLifecycleProvider.notifier).state =
            perf.AppLifecycleState.inactive;
        break;
      default:
        break;
    }
  }

  /// Override to handle app resume (e.g., refresh data)
  void onAppResumed() {}

  /// Override to handle app pause (e.g., save state)
  void onAppPaused() {}

  @override
  void didChangeAccessibilityFeatures() {}

  @override
  void didChangeLocales(List<Locale>? locales) {}

  @override
  void didChangeMetrics() {}

  @override
  void didChangePlatformBrightness() {}

  @override
  void didChangeTextScaleFactor() {}

  @override
  void didHaveMemoryPressure() {
    // Clear caches when memory is low
    onMemoryPressure();
  }

  /// Override to handle memory pressure (e.g., clear caches)
  void onMemoryPressure() {}

  @override
  Future<bool> didPopRoute() async => false;

  @override
  Future<bool> didPushRoute(String route) async => false;

  @override
  Future<bool> didPushRouteInformation(
          RouteInformation routeInformation) async =>
      false;

  @override
  Future<ui.AppExitResponse> didRequestAppExit() async =>
      ui.AppExitResponse.exit;
}
