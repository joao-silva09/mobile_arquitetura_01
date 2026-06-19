import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  static const String baseUrl = 'https://dummyjson.com/products';

  final http.Client client;
  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar produtos');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List products = data['products'];
    return products
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar produto');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return ProductModel.fromJson(data);
  }
}
