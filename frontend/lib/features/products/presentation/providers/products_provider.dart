import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/vendor.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/datasources/mock_product_datasource.dart';
import '../../data/datasources/supabase_product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../../../core/services/logger_service.dart';

// ============================================
// CONFIGURATION: Set to true for real backend
// ============================================
const bool useRealBackend = true;

// Logger provider
final _loggerProvider = Provider<LoggerService>((ref) => const LoggerService());

// Supabase datasource provider
final _supabaseDataSourceProvider = Provider<SupabaseProductDataSource>((ref) {
  final client = Supabase.instance.client;
  final logger = ref.watch(_loggerProvider);
  return SupabaseProductDataSource(client, logger);
});

// Mock datasource provider (fallback)
final _mockDataSourceProvider = Provider<MockProductDataSource>((ref) {
  return MockProductDataSource();
});

// Repository provider (switches between real and mock)
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(_mockDataSourceProvider));
});

// ============================================
// ASYNC PRODUCTS PROVIDER (Real Backend)
// ============================================
final productsAsyncProvider = FutureProvider<List<Product>>((ref) async {
  if (!useRealBackend) {
    return ref.watch(_mockDataSourceProvider).getProducts();
  }

  try {
    final dataSource = ref.watch(_supabaseDataSourceProvider);
    final products = await dataSource.getProducts();
    if (products.isEmpty) {
      // Fallback to mock if no data
      return ref.watch(_mockDataSourceProvider).getProducts();
    }
    return products;
  } catch (e) {
    // Fallback to mock on error
    print('⚠️ Supabase error, using mock data: $e');
    return ref.watch(_mockDataSourceProvider).getProducts();
  }
});

// ============================================
// SYNC PRODUCTS PROVIDER (For compatibility)
// Returns mock data immediately, refreshes from backend
// ============================================
final productsProvider = Provider<List<Product>>((ref) {
  // Start with mock data for immediate display
  final mockProducts = ref.watch(_mockDataSourceProvider).getProducts();

  // Also watch async provider to trigger backend fetch
  final asyncProducts = ref.watch(productsAsyncProvider);

  return asyncProducts.when(
    data: (products) => products.isNotEmpty ? products : mockProducts,
    loading: () => mockProducts,
    error: (_, __) => mockProducts,
  );
});

// ============================================
// CATEGORIES PROVIDER
// ============================================
final categoriesAsyncProvider = FutureProvider<List<Category>>((ref) async {
  if (!useRealBackend) {
    return ref.watch(_mockDataSourceProvider).getCategories();
  }

  try {
    final dataSource = ref.watch(_supabaseDataSourceProvider);
    final categories = await dataSource.getCategories();
    if (categories.isEmpty) {
      return ref.watch(_mockDataSourceProvider).getCategories();
    }
    return categories;
  } catch (e) {
    print('⚠️ Supabase categories error, using mock: $e');
    return ref.watch(_mockDataSourceProvider).getCategories();
  }
});

final categoriesProvider = Provider<List<Category>>((ref) {
  final mockCategories = ref.watch(_mockDataSourceProvider).getCategories();
  final asyncCategories = ref.watch(categoriesAsyncProvider);

  return asyncCategories.when(
    data: (categories) => categories.isNotEmpty ? categories : mockCategories,
    loading: () => mockCategories,
    error: (_, __) => mockCategories,
  );
});

// ============================================
// SEARCH PROVIDER
// ============================================
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  if (!useRealBackend) {
    return ref.watch(_mockDataSourceProvider).searchProducts(query);
  }

  try {
    final dataSource = ref.watch(_supabaseDataSourceProvider);
    return await dataSource.searchProducts(query);
  } catch (e) {
    return ref.watch(_mockDataSourceProvider).searchProducts(query);
  }
});

// ============================================
// CATEGORY FILTER
// ============================================
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (selectedCategory == null || selectedCategory.isEmpty) {
    return products;
  }

  return products
      .where((p) => p.category.toLowerCase() == selectedCategory.toLowerCase())
      .toList();
});

// ============================================
// SINGLE PRODUCT
// ============================================
final productProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsProvider);
  try {
    return products.firstWhere((p) => p.id == id);
  } catch (e) {
    return null;
  }
});

// ============================================
// VENDORS PROVIDER (For Hub/Farm toggle)
// ============================================
final vendorsProvider = FutureProvider<List<Vendor>>((ref) async {
  if (!useRealBackend) {
    // Return mock vendors if backend not enabled
    return [
      const Vendor(
          id: 'v1',
          name: 'Green Valley Farms',
          imageUrl:
              'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?w=400',
          rating: 4.8,
          reviewCount: 120,
          isVerified: true,
          location: 'Nashik, MH'),
      const Vendor(
          id: 'v2',
          name: 'Organic Roots',
          imageUrl:
              'https://images.unsplash.com/photo-1595908237730-745145b38cb7?w=400',
          rating: 4.5,
          reviewCount: 85,
          isVerified: true,
          location: 'Pune, MH'),
      const Vendor(
          id: 'v3',
          name: 'Fresh Fields',
          imageUrl:
              'https://images.unsplash.com/photo-1605000797499-95a51c5269ae?w=400',
          rating: 4.2,
          reviewCount: 45,
          isVerified: true,
          location: 'Nagpur, MH'),
    ];
  }

  try {
    final dataSource = ref.watch(_supabaseDataSourceProvider);
    final data = await dataSource.getVendors();
    return data.map((json) => Vendor.fromJson(json)).toList();
  } catch (e) {
    print('Error fetching vendors: $e');
    return [];
  }
});
