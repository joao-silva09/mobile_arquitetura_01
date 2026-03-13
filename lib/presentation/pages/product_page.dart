import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      body: productsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('Erro ao carregar produtos: $error'),
        ),
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              leading: Image.network(
                product.image,
                width: 44,
                height: 44,
                fit: BoxFit.contain,
              ),
              title: Text(product.title),
              subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
              trailing: IconButton(
                onPressed: () {
                  ref
                      .read(productViewModelProvider.notifier)
                      .toggleFavorite(product.id);
                },
                icon: Icon(
                  product.favorite ? Icons.star : Icons.star_border,
                  color: product.favorite ? Colors.amber : Colors.grey,
                ),
                tooltip: product.favorite
                    ? 'Remover dos favoritos'
                    : 'Adicionar aos favoritos',
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(productViewModelProvider.notifier).loadProducts();
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
