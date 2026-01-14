import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../../../core/services/logger_service.dart';

/// Real Supabase datasource for products and categories
/// Replaces MockProductDataSource with actual backend calls
class SupabaseProductDataSource {
  final SupabaseClient _client;
  final LoggerService _logger;

  SupabaseProductDataSource(this._client, this._logger);

  /// Fetch all active products from Supabase
  Future<List<Product>> getProducts() async {
    try {
      _logger.d('Fetching all products from Supabase');

      final response = await _client.from('products').select('''
            id,
            name,
            description,
            price,
            stock,
            is_active,
            image_url,
            vendor_id,
            category_id,
            categories (
              id,
              name
            ),
            vendors (
              id,
              shop_name
            )
          ''').eq('is_active', true).order('created_at', ascending: false);

      final products = (response as List).map((json) {
        return Product(
          id: json['id'] as String,
          name: json['name'] as String,
          description: json['description'] as String? ?? '',
          price: (json['price'] as num).toDouble(),
          imageUrl: json['image_url'] as String? ??
              _getProductImage(json['category_id']),
          category: json['categories']?['name'] as String? ?? 'Uncategorized',
          rating: 4.5, // Default rating (can add review system later)
          reviewCount: 0,
          stock: json['stock'] as int? ?? 0,
          unit: 'kg', // Default unit
          discount: null,
          vendorName: json['vendors']?['shop_name'] as String?,
        );
      }).toList();

      _logger.i('Fetched ${products.length} products from Supabase');
      return products;
    } catch (e, stack) {
      _logger.e('Failed to fetch products', e, stack);
      rethrow;
    }
  }

  /// Fetch product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final response = await _client.from('products').select('''
            id,
            name,
            description,
            price,
            stock,
            is_active,
            image_url,
            category_id,
            categories (
              id,
              name
            ),
            vendors (
              id,
              shop_name
            )
          ''').eq('id', id).single();

      return Product(
        id: response['id'] as String,
        name: response['name'] as String,
        description: response['description'] as String? ?? '',
        price: (response['price'] as num).toDouble(),
        imageUrl: response['image_url'] as String? ??
            _getProductImage(response['category_id']),
        category: response['categories']?['name'] as String? ?? 'Uncategorized',
        rating: 4.5,
        reviewCount: 0,
        stock: response['stock'] as int? ?? 0,
        unit: 'kg',
        discount: null,
        vendorName: response['vendors']?['shop_name'] as String?,
      );
    } catch (e) {
      _logger.w('Product not found: $id');
      return null;
    }
  }

  /// Search products by name or description
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _client
          .from('products')
          .select('''
            id,
            name,
            description,
            price,
            stock,
            image_url,
            category_id,
            categories (name),
            vendors (shop_name)
          ''')
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .limit(20);

      return (response as List)
          .map((json) => Product(
                id: json['id'] as String,
                name: json['name'] as String,
                description: json['description'] as String? ?? '',
                price: (json['price'] as num).toDouble(),
                imageUrl: json['image_url'] as String? ??
                    _getProductImage(json['category_id']),
                category:
                    json['categories']?['name'] as String? ?? 'Uncategorized',
                rating: 4.5,
                reviewCount: 0,
                stock: json['stock'] as int? ?? 0,
                unit: 'kg',
                vendorName: json['vendors']?['shop_name'] as String?,
              ))
          .toList();
    } catch (e, stack) {
      _logger.e('Search failed', e, stack);
      return [];
    }
  }

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _client.from('products').select('''
            id,
            name,
            description,
            price,
            stock,
            image_url,
            category_id,
            categories (name),
            vendors (shop_name)
          ''').eq('is_active', true).eq('category_id', categoryId);

      return (response as List)
          .map((json) => Product(
                id: json['id'] as String,
                name: json['name'] as String,
                description: json['description'] as String? ?? '',
                price: (json['price'] as num).toDouble(),
                imageUrl: json['image_url'] as String? ??
                    _getProductImage(json['category_id']),
                category:
                    json['categories']?['name'] as String? ?? 'Uncategorized',
                rating: 4.5,
                reviewCount: 0,
                stock: json['stock'] as int? ?? 0,
                unit: 'kg',
                vendorName: json['vendors']?['shop_name'] as String?,
              ))
          .toList();
    } catch (e, stack) {
      _logger.e('Failed to fetch products by category', e, stack);
      return [];
    }
  }

  /// Fetch all active categories
  Future<List<Category>> getCategories() async {
    try {
      _logger.d('Fetching categories from Supabase');

      final response = await _client
          .from('categories')
          .select('id, name, is_active')
          .eq('is_active', true)
          .order('name');

      final categories = (response as List).map((json) {
        final name = json['name'] as String;
        return Category(
          id: json['id'] as String,
          name: name,
          icon: _getCategoryIcon(name),
          imageUrl: _getCategoryImage(name),
          productCount: 0, // Can be filled with count query
        );
      }).toList();

      _logger.i('Fetched ${categories.length} categories from Supabase');
      return categories;
    } catch (e, stack) {
      _logger.e('Failed to fetch categories', e, stack);
      return [];
    }
  }

  /// Get vendors (for Hub/Farm toggle)
  Future<List<Map<String, dynamic>>> getVendors() async {
    try {
      final response = await _client
          .from('vendors')
          .select('id, shop_name, phone, address, status')
          .eq('status', 'approved');

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stack) {
      _logger.e('Failed to fetch vendors', e, stack);
      return [];
    }
  }

  /// Get products by vendor
  Future<List<Product>> getProductsByVendor(String vendorId) async {
    try {
      final response = await _client.from('products').select('''
            id,
            name,
            description,
            price,
            stock,
            image_url,
            category_id,
            categories (name)
          ''').eq('vendor_id', vendorId).eq('is_active', true);

      return (response as List)
          .map((json) => Product(
                id: json['id'] as String,
                name: json['name'] as String,
                description: json['description'] as String? ?? '',
                price: (json['price'] as num).toDouble(),
                imageUrl: json['image_url'] as String? ??
                    _getProductImage(json['category_id']),
                category:
                    json['categories']?['name'] as String? ?? 'Uncategorized',
                rating: 4.5,
                reviewCount: 0,
                stock: json['stock'] as int? ?? 0,
                unit: 'kg',
              ))
          .toList();
    } catch (e, stack) {
      _logger.e('Failed to fetch vendor products', e, stack);
      return [];
    }
  }

  // Helper to get category icon based on name
  String _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'vegetables':
        return '🥬';
      case 'fruits':
        return '🍎';
      case 'dairy':
        return '🥛';
      case 'grains':
        return '🌾';
      case 'spices':
        return '🌶️';
      case 'bakery':
        return '🍞';
      case 'beverages':
        return '🥤';
      default:
        return '🛒';
    }
  }

  // Helper to get category image URL
  String _getCategoryImage(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'vegetables':
        return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400';
      case 'fruits':
        return 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400';
      case 'dairy':
        return 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400';
      case 'grains':
        return 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400';
      case 'spices':
        return 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400';
      default:
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400';
    }
  }

  // Helper to get product image based on category
  String _getProductImage(String? categoryId) {
    // For now return a default image, in production would use storage
    return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400';
  }
}
