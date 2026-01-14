import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/providers/products_provider.dart';

/// Cached products provider - prevents unnecessary refetches
/// Use this instead of productsProvider when you want caching
final cachedProductsProvider = Provider<List<Product>>((ref) {
  // KeepAlive ensures the data isn't disposed when all listeners are removed
  ref.keepAlive();
  return ref.watch(productsProvider);
});

/// Selected product cache for detail views
/// Avoids refetching when navigating back and forth
final selectedProductCacheProvider = StateProvider.family<Product?, String>(
  (ref, productId) => null,
);

/// Product with cache-first strategy
final cachedProductProvider = Provider.family<Product?, String>((ref, id) {
  // First check cache
  final cached = ref.watch(selectedProductCacheProvider(id));
  if (cached != null) return cached;

  // Otherwise fetch from repository
  final product = ref.watch(productProvider(id));

  // Store in cache for future use
  if (product != null) {
    Future.microtask(() {
      ref.read(selectedProductCacheProvider(id).notifier).state = product;
    });
  }

  return product;
});

/// Debounce provider for search - prevents excessive API calls
class DebouncedSearchNotifier extends StateNotifier<String> {
  DebouncedSearchNotifier() : super('');

  Future<void>? _debounceTimer;

  void updateQuery(String query) {
    _debounceTimer?.ignore();
    _debounceTimer = Future.delayed(const Duration(milliseconds: 300), () {
      state = query;
    });
  }

  void clearQuery() {
    _debounceTimer?.ignore();
    state = '';
  }
}

final debouncedSearchProvider =
    StateNotifierProvider<DebouncedSearchNotifier, String>(
  (ref) => DebouncedSearchNotifier(),
);

/// Pagination state for infinite scroll lists
class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final int page;
  final String? error;

  const PaginationState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    int? page,
    String? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      error: error,
    );
  }

  PaginationState<T> startLoading() => copyWith(isLoading: true, error: null);

  PaginationState<T> addItems(List<T> newItems, {int pageSize = 20}) {
    return copyWith(
      items: [...items, ...newItems],
      isLoading: false,
      hasMore: newItems.length >= pageSize,
      page: page + 1,
    );
  }

  PaginationState<T> setError(String message) => copyWith(
        isLoading: false,
        error: message,
      );

  PaginationState<T> reset() => const PaginationState();
}

/// App lifecycle state for managing background/foreground transitions
enum AppLifecycleState {
  active,
  inactive,
  paused,
  resumed,
}

final appLifecycleProvider = StateProvider<AppLifecycleState>(
  (ref) => AppLifecycleState.active,
);
