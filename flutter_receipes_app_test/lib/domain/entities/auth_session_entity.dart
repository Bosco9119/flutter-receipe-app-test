import 'package:flutter/foundation.dart';

@immutable
class AuthSessionEntity {
  const AuthSessionEntity({
    required this.username,
    required this.issuedAt,
  });

  final String username;
  final DateTime issuedAt;
}
