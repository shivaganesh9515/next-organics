import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/mock_product_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final MockProductDataSource _dataSource;

  ProductRepositoryImpl(this._dataSource);

  @override
  List<Product> getProducts() {
    return _dataSource.getProducts();
  }

  @override
  Product? getProductById(String id) {
    return _dataSource.getProductById(id);
  }

  @override
  List<Product> searchProducts(String query) {
    return _dataSource.searchProducts(query);
  }

  @override
  List<Product> getProductsByCategory(String categoryId) {
    return _dataSource.getProductsByCategory(categoryId);
  }

  @override
  List<Category> getCategories() {
    return _dataSource.getCategories();
  }
}
