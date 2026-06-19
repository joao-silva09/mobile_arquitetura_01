import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/core/session/session_controller.dart';
import 'package:product_app/presentation/pages/login_page.dart';
import 'package:product_app/presentation/pages/product_detail_page.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionControllerProvider);
    final user = sessionState.user;

    if (user == null) {
      return const LoginPage();
    }

    final productsState = ref.watch(productViewModelProvider);
    final productViewModel = ref.read(productViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(user.firstName),
            ),
          ),
          IconButton(
            onPressed: () {
              ref.read(sessionControllerProvider.notifier).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: productsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ProductError(
          error: error,
          onReload: productViewModel.loadProducts,
        ),
        data: (products) {
          if (products.isEmpty) {
            return _EmptyProducts(onReload: productViewModel.loadProducts);
          }

          return RefreshIndicator(
            onRefresh: productViewModel.loadProducts,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ListTile(
                  leading: Image.network(
                    product.thumbnail,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.image),
                  ),
                  title: Text(product.title),
                  subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    onPressed: () {
                      productViewModel.toggleFavorite(product.id);
                    },
                    icon: Icon(
                      product.favorite ? Icons.star : Icons.star_border,
                      color: product.favorite ? Colors.amber : Colors.grey,
                    ),
                    tooltip: product.favorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailPage(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: productViewModel.loadProducts,
        tooltip: 'Recarregar',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _ProductError extends StatelessWidget {
  final Object error;
  final Future<void> Function() onReload;

  const _ProductError({required this.error, required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Erro ao carregar produtos: $error',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReload,
              icon: const Icon(Icons.refresh),
              label: const Text('Recarregar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  final Future<void> Function() onReload;

  const _EmptyProducts({required this.onReload});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onReload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Sem produtos'),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onReload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recarregar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
