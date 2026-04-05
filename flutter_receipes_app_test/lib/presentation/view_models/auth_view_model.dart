import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository) {
    _subscription = _repository.watchSession().listen((session) {
      _session = session;
      notifyListeners();
    });
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthSessionEntity?> _subscription;

  AuthSessionEntity? _session;
  AuthSessionEntity? get session => _session;

  bool get isAuthenticated => _session != null;

  Future<void> login(String username, String password) {
    return _repository.login(username: username, password: password);
  }

  Future<void> signInWithGoogle() => _repository.signInWithGoogle();

  Future<void> logout() => _repository.logout();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
