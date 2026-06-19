import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/core/session/session_controller.dart';
import 'package:product_app/data/datasources/auth_remote_datasource.dart';
import 'package:product_app/data/repositories/auth_repository.dart';
import 'package:product_app/data/repositories/auth_repository_impl.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);

  return AuthRepositoryImpl(AuthRemoteDatasource(client));
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(
    ref.watch(authRepositoryProvider),
    ref.watch(sessionControllerProvider.notifier),
  );
});

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.errorMessage});

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SessionController _sessionController;

  AuthViewModel(this._repository, this._sessionController)
    : super(const AuthState());

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearErrorMessage: true);

    try {
      final user = await _repository.login(
        username: username.trim(),
        password: password.trim(),
      );
      _sessionController.login(user);
      state = state.copyWith(isLoading: false, clearErrorMessage: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _readableError(error),
      );
      return false;
    }
  }

  String _readableError(Object error) {
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }
}
