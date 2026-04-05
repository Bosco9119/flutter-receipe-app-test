import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// Hashing + symmetric encryption helpers for auth/session demos.
/// Production apps should derive keys with platform secure storage.
class CryptoService {
  CryptoService({String? passphrase})
      : _passphrase = passphrase ?? _defaultPassphrase;

  static const _defaultPassphrase = 'recipe_app_dev_passphrase_change_me';
  final String _passphrase;

  String hashCredential(String value) {
    final bytes = utf8.encode('$_passphrase::$value');
    return sha256.convert(bytes).toString();
  }

  bool verifyHash(String value, String expectedHex) {
    return hashCredential(value) == expectedHex;
  }

  Encrypter _encrypter() {
    final keyBytes = Uint8List.fromList(_keyBytes(_passphrase));
    final key = Key(keyBytes);
    return Encrypter(AES(key));
  }

  List<int> _keyBytes(String input) {
    return sha256.convert(utf8.encode(input)).bytes;
  }

  String encryptPayload(String plain) {
    final iv = IV.fromSecureRandom(16);
    final enc = _encrypter();
    final encrypted = enc.encrypt(plain, iv: iv);
    return jsonEncode({
      'iv': iv.base64,
      'data': encrypted.base64,
    });
  }

  String decryptPayload(String serialized) {
    final map = jsonDecode(serialized) as Map<String, dynamic>;
    final iv = IV.fromBase64(map['iv'] as String);
    final enc = Encrypted.fromBase64(map['data'] as String);
    return _encrypter().decrypt(enc, iv: iv);
  }
}
