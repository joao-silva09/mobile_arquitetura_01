import 'dart:io';

import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final HttpClient client;
  ProductRemoteDatasource(this.client);
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get("https://fakestoreapi.com/products");
    final List data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
