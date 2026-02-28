import '../../core/api_client.dart';

class ProductRepository {
  final ApiClient apiClient;

  ProductRepository(this.apiClient);

  Future<List<dynamic>> fetchProducts(String category) async {
    if (category == 'all') {
      return await apiClient.get('/products');
    }

    return await apiClient.get('/products/category/$category');
  }
}