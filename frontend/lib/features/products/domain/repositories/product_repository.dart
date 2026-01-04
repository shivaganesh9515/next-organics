import '../entities/product.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  List<Product> getProducts();
  Product? getProductById(String id);
  List<Product> searchProducts(String query);
  List<Product> getProductsByCategory(String categoryId);
  List<Category> getCategories();
}
