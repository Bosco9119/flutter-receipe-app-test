import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_receipes_app_test/domain/entities/auth_session_entity.dart';
import 'package:flutter_receipes_app_test/domain/repositories/auth_repository.dart';
import 'package:flutter_receipes_app_test/l10n/app_localizations.dart';
import 'package:flutter_receipes_app_test/presentation/view_models/auth_view_model.dart';
import 'package:flutter_receipes_app_test/presentation/views/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Stream<AuthSessionEntity?> watchSession() => Stream.value(null);

  @override
  Future<AuthSessionEntity> login({
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('LoginPage shows credential fields', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ChangeNotifierProvider(
          create: (_) => AuthViewModel(_FakeAuthRepository()),
          child: const LoginPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
