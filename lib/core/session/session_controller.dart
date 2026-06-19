import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_app/core/session/session_state.dart';
import 'package:product_app/domain/entities/auth_user.dart';

final sessionControllerProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
      return SessionController();
    });

class SessionController extends StateNotifier<SessionState> {
  SessionController() : super(const SessionState());

  void login(AuthUser user) {
    state = SessionState(user: user);
  }

  void logout() {
    state = const SessionState();
  }
}
