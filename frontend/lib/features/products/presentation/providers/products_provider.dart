import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/datasources/mock_product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';

// Data source provider
final productDataSourceProvider = Provider<MockProductDataSource>((ref) {
  return MockProductDataSource();
});

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productDataSourceProvider));
});

// Products provider (SYNC)
final productsProvider = Provider<List<Product>>((ref) {
  print('PROVIDER: productsProvider called (SYNC)');
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

// Categories provider (SYNC)
final categoriesProvider = Provider<List<Category>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getCategories();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Filtered products provider (SYNC logic but might need recalculation)
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (searchQuery.isNotEmpty) {
    return repository.searchProducts(searchQuery);
  } else if (selectedCategory != null) {
    return repository.getProductsByCategory(selectedCategory);
  } else {
    return repository.getProducts();
  }
});

// Single product provider (SYNC)
final productProvider = Provider.family<Product?, String>((ref, id) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
});
