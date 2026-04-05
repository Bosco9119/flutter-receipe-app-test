import '../entities/auth_session_entity.dart';

abstract class AuthRepository {
  Stream<AuthSessionEntity?> watchSession();

  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  });

  Future<void> logout();
}
