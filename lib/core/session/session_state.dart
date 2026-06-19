import 'package:product_app/domain/entities/auth_user.dart';

class SessionState {
  final AuthUser? user;

  const SessionState({this.user});

  bool get isAuthenticated => user != null;
}
