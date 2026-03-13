import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/data/repositories/product_repository.dart';
import 'package:product_app/domain/entities/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);

  final datasource = ProductRemoteDatasource(client);
  return ProductRepositoryImpl(datasource);
});

final productViewModelProvider =
    StateNotifierProvider<ProductViewModel, AsyncValue<List<Product>>>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      final notifier = ProductViewModel(repository);
      notifier.loadProducts();
      return notifier;
    });

class ProductViewModel extends StateNotifier<AsyncValue<List<Product>>> {
  final ProductRepository repository;

  ProductViewModel(this.repository) : super(const AsyncValue.loading());

  Future<void> loadProducts() async {
    state = const AsyncValue.loading();

    try {
      final result = await repository.getProducts();
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void toggleFavorite(int productId) {
    final currentProducts = state.value;
    if (currentProducts == null) {
      return;
    }

    final updated = currentProducts.map((product) {
      if (product.id == productId) {
        return product.copyWith(favorite: !product.favorite);
      }

      return product;
    }).toList();

    state = AsyncValue.data(updated);
  }
}
