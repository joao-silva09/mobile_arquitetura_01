import 'package:product_app/data/datasources/auth_remote_datasource.dart';
import 'package:product_app/data/repositories/auth_repository.dart';
import 'package:product_app/domain/entities/auth_user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final model = await datasource.login(
      username: username,
      password: password,
    );
    return model.toEntity();
  }
}
