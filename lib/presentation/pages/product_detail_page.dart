import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

final _productDetailProvider = FutureProvider.autoDispose.family<Product?, int>(
  (ref, productId) {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProductById(productId);
  },
);

class ProductDetailPage extends ConsumerWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(_productDetailProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
        ),
      ),
      body: productState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            _DetailMessage(message: 'Erro ao carregar produto: $error'),
        data: (product) {
          if (product == null) {
            return const _DetailMessage(message: 'Produto nao encontrado');
          }

          return _ProductDetailContent(product: product);
        },
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  final Product product;

  const _ProductDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: product.thumbnail.isEmpty
              ? const ColoredBox(
                  color: Color(0xFFE0E0E0),
                  child: Icon(Icons.image, size: 64),
                )
              : Image.network(
                  product.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(
                    color: Color(0xFFE0E0E0),
                    child: Icon(Icons.image, size: 64),
                  ),
                ),
        ),
        const SizedBox(height: 24),
        Text(product.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'R\$ ${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          product.description.isEmpty
              ? 'Descricao indisponivel'
              : product.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        _DetailRow(label: 'Categoria', value: product.category),
        _DetailRow(
          label: 'Avaliacao',
          value: product.rating.toStringAsFixed(1),
        ),
        _DetailRow(label: 'Estoque', value: product.stock.toString()),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}

class _DetailMessage extends StatelessWidget {
  final String message;

  const _DetailMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
