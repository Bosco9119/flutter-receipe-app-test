import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_receipes_app_test/core/security/crypto_service.dart';

void main() {
  group('CryptoService', () {
    test('hashCredential is stable for same input', () {
      final crypto = CryptoService(passphrase: 'test-secret');
      expect(crypto.hashCredential('demo'), crypto.hashCredential('demo'));
    });

    test('verifyHash accepts matching password', () {
      final crypto = CryptoService(passphrase: 'test-secret');
      final hash = crypto.hashCredential('secret-password');
      expect(crypto.verifyHash('secret-password', hash), isTrue);
      expect(crypto.verifyHash('other', hash), isFalse);
    });

    test('encryptPayload round-trips', () {
      final crypto = CryptoService(passphrase: 'round-trip');
      const plain = 'session-payload';
      final sealed = crypto.encryptPayload(plain);
      expect(crypto.decryptPayload(sealed), plain);
    });
  });
}
