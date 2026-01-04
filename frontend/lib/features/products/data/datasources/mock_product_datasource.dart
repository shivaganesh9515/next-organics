import 'package:flutter/foundation.dart' hide Category;
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';

class MockProductDataSource {
  // Mock delay to simulate network call
  static const _delay = Duration(milliseconds: 500);

  List<Product> getProducts() {
    print('MockProductDataSource: getProducts called (SYNC)');
    return _mockProducts;
  }

  Product? getProductById(String id) {
    try {
      return _mockProducts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Product> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _mockProducts.where((product) {
      return product.name.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  List<Product> getProductsByCategory(String categoryId) {
    return _mockProducts.where((p) => p.category == categoryId).toList();
  }

  List<Category> getCategories() {
    return _mockCategories;
  }

  // Mock Categories
  static final List<Category> _mockCategories = [
    const Category(
      id: 'fruits',
      name: 'Fruits',
      icon: '🍎',
      imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400',
      productCount: 12,
    ),
    const Category(
      id: 'vegetables',
      name: 'Vegetables',
      icon: '🥬',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
      productCount: 15,
    ),
    const Category(
      id: 'dairy',
      name: 'Dairy',
      icon: '🥛',
      imageUrl: 'https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400',
      productCount: 8,
    ),
    const Category(
      id: 'beverages',
      name: 'Beverages',
      icon: '🥤',
      imageUrl: 'https://images.unsplash.com/photo-1546173159-315724a31696?w=400',
      productCount: 10,
    ),
    const Category(
      id: 'snacks',
      name: 'Snacks',
      icon: '🍿',
      imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400',
      productCount: 18,
    ),
    const Category(
      id: 'bakery',
      name: 'Bakery',
      icon: '🍞',
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
      productCount: 9,
    ),
  ];

  // Mock Products (INR Prices)
  static final List<Product> _mockProducts = [
    // Fruits
    const Product(
      id: '1',
      name: 'Fresh Organic Apples',
      description: 'Crisp and sweet organic apples, perfect for snacking',
      price: 399.0,
      imageUrl: 'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400',
      category: 'fruits',
      rating: 4.5,
      reviewCount: 128,
      stock: 50,
      unit: 'kg',
      discount: 10,
    ),
    const Product(
      id: '2',
      name: 'Bananas',
      description: 'Fresh yellow bananas, rich in potassium',
      price: 199.0,
      imageUrl: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
      category: 'fruits',
      rating: 4.7,
      reviewCount: 95,
      stock: 100,
      unit: 'dozen',
    ),
    const Product(
      id: '3',
      name: 'Strawberries',
      description: 'Sweet and juicy strawberries',
      price: 499.0,
      imageUrl: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      category: 'fruits',
      rating: 4.8,
      reviewCount: 156,
      stock: 30,
      unit: 'box',
      discount: 15,
    ),
    const Product(
      id: '4',
      name: 'Avocados',
      description: 'Fresh Hass avocados, perfectly ripe',
      price: 349.0,
      imageUrl: 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=400',
      category: 'fruits',
      rating: 4.6,
      reviewCount: 87,
      stock: 40,
      unit: 'pack',
    ),
    const Product(
      id: '5',
      name: 'Oranges',
      description: 'Juicy Valencia oranges, vitamin C rich',
      price: 299.0,
      imageUrl: 'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
      category: 'fruits',
      rating: 4.4,
      reviewCount: 73,
      stock: 60,
      unit: 'kg',
    ),

    // Vegetables
    const Product(
      id: '6',
      name: 'Fresh Tomatoes',
      description: 'Vine-ripened organic tomatoes',
      price: 249.0,
      imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=400',
      category: 'vegetables',
      rating: 4.5,
      reviewCount: 112,
      stock: 80,
      unit: 'kg',
      discount: 5,
    ),
    const Product(
      id: '7',
      name: 'Baby Spinach',
      description: 'Fresh organic baby spinach leaves',
      price: 149.0,
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      category: 'vegetables',
      rating: 4.6,
      reviewCount: 89,
      stock: 45,
      unit: 'bag',
    ),
    const Product(
      id: '8',
      name: 'Broccoli',
      description: 'Fresh green broccoli crowns',
      price: 129.0,
      imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400',
      category: 'vegetables',
      rating: 4.3,
      reviewCount: 64,
      stock: 35,
      unit: 'bunch',
    ),
    const Product(
      id: '9',
      name: 'Bell Peppers',
      description: 'Colorful mixed bell peppers',
      price: 329.0,
      imageUrl: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      category: 'vegetables',
      rating: 4.7,
      reviewCount: 102,
      stock: 55,
      unit: 'pack',
      discount: 8,
    ),
    const Product(
      id: '10',
      name: 'Carrots',
      description: 'Sweet and crunchy organic carrots',
      price: 99.0,
      imageUrl: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      category: 'vegetables',
      rating: 4.5,
      reviewCount: 78,
      stock: 90,
      unit: 'kg',
    ),

    // Dairy
    const Product(
      id: '11',
      name: 'Organic Whole Milk',
      description: 'Fresh organic whole milk, 1 gallon',
      price: 350.0,
      imageUrl: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400',
      category: 'dairy',
      rating: 4.8,
      reviewCount: 203,
      stock: 70,
      unit: 'gallon',
    ),
    const Product(
      id: '12',
      name: 'Greek Yogurt',
      description: 'Creamy Greek yogurt, plain',
      price: 240.0,
      imageUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
      category: 'dairy',
      rating: 4.7,
      reviewCount: 167,
      stock: 55,
      unit: 'container',
      discount: 12,
    ),
    const Product(
      id: '13',
      name: 'Cheddar Cheese',
      description: 'Sharp cheddar cheese block',
      price: 450.0,
      imageUrl: 'https://images.unsplash.com/photo-1452195100486-9cc805987862?w=400',
      category: 'dairy',
      rating: 4.6,
      reviewCount: 134,
      stock: 40,
      unit: 'block',
    ),
    const Product(
      id: '14',
      name: 'Butter',
      description: 'Unsalted organic butter',
      price: 320.0,
      imageUrl: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=400',
      category: 'dairy',
      rating: 4.5,
      reviewCount: 98,
      stock: 60,
      unit: 'pack',
    ),

    // Beverages
    const Product(
      id: '15',
      name: 'Orange Juice',
      description: 'Fresh-squeezed orange juice',
      price: 299.0,
      imageUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
      category: 'beverages',
      rating: 4.6,
      reviewCount: 145,
      stock: 50,
      unit: 'bottle',
      discount: 10,
    ),
    const Product(
      id: '16',
      name: 'Green Tea',
      description: 'Organic green tea bags, 100 count',
      price: 599.0,
      imageUrl: 'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400',
      category: 'beverages',
      rating: 4.7,
      reviewCount: 189,
      stock: 75,
      unit: 'box',
    ),
    const Product(
      id: '17',
      name: 'Sparkling Water',
      description: 'Natural sparkling water, 12-pack',
      price: 449.0,
      imageUrl: 'https://images.unsplash.com/photo-1523362628745-0c100150b8d6?w=400',
      category: 'beverages',
      rating: 4.4,
      reviewCount: 112,
      stock: 85,
      unit: 'pack',
    ),
    const Product(
      id: '18',
      name: 'Cold Brew Coffee',
      description: 'Premium cold brew coffee concentrate',
      price: 549.0,
      imageUrl: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
      category: 'beverages',
      rating: 4.8,
      reviewCount: 234,
      stock: 45,
      unit: 'bottle',
      discount: 20,
    ),

    // Snacks
    const Product(
      id: '19',
      name: 'Mixed Nuts',
      description: 'Roasted and salted mixed nuts',
      price: 699.0,
      imageUrl: 'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=400',
      category: 'snacks',
      rating: 4.7,
      reviewCount: 178,
      stock: 65,
      unit: 'bag',
    ),
    const Product(
      id: '20',
      name: 'Organic Granola',
      description: 'Honey and almond granola',
      price: 449.0,
      imageUrl: 'https://images.unsplash.com/photo-1526318896980-cf78c088247c?w=400',
      category: 'snacks',
      rating: 4.6,
      reviewCount: 156,
      stock: 55,
      unit: 'bag',
      discount: 15,
    ),
    const Product(
      id: '21',
      name: 'Dark Chocolate',
      description: '70% cacao dark chocolate bar',
      price: 249.0,
      imageUrl: 'https://images.unsplash.com/photo-1511381939415-e44015466834?w=400',
      category: 'snacks',
      rating: 4.8,
      reviewCount: 267,
      stock: 80,
      unit: 'bar',
    ),
    const Product(
      id: '22',
      name: 'Potato Chips',
      description: 'Sea salt kettle-cooked chips',
      price: 299.0,
      imageUrl: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400',
      category: 'snacks',
      rating: 4.5,
      reviewCount: 189,
      stock: 90,
      unit: 'bag',
      discount: 5,
    ),

    // Bakery
    const Product(
      id: '23',
      name: 'Whole Wheat Bread',
      description: 'Freshly baked whole wheat bread',
      price: 199.0,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400',
      category: 'bakery',
      rating: 4.6,
      reviewCount: 143,
      stock: 40,
      unit: 'loaf',
    ),
    const Product(
      id: '24',
      name: 'Croissants',
      description: 'Buttery French croissants, 6-pack',
      price: 349.0,
      imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=400',
      category: 'bakery',
      rating: 4.8,
      reviewCount: 198,
      stock: 30,
      unit: 'pack',
      discount: 10,
    ),
    const Product(
      id: '25',
      name: 'Bagels',
      description: 'Assorted bagels, 6-pack',
      price: 299.0,
      imageUrl: 'https://images.unsplash.com/photo-1551106652-a5bcf4b29e84?w=400',
      category: 'bakery',
      rating: 4.5,
      reviewCount: 122,
      stock: 50,
      unit: 'pack',
    ),
  ];
}
