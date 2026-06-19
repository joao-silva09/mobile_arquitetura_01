import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_app/data/models/auth_user_model.dart';

class AuthRemoteDatasource {
  static const String baseUrl = 'https://dummyjson.com/auth';

  final http.Client client;

  AuthRemoteDatasource(this.client);

  Future<AuthUserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Usuario ou senha invalidos');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    return AuthUserModel.fromJson(data);
  }
}
