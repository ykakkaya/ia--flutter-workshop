import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_exception.dart';
import '../core/providers.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

/// Oturum durumu: `data == null` → giriş yapılmamış.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final storage = ref.read(tokenStorageProvider);
    if (await storage.read() == null) return null;
    try {
      return await ref.read(authRepositoryProvider).me();
    } on ApiException catch (e) {
      if (e.isUnauthenticated) await storage.clear();
      return null;
    }
  }

  Future<void> _authenticate(Future<AuthResult> Function() call) async {
    final result = await call();
    await ref.read(tokenStorageProvider).save(result.token);
    state = AsyncData(result.user);
  }

  /// Hata durumunda [ApiException] fırlatır (form ekranı gösterir).
  Future<void> login(String email, String password) => _authenticate(
      () => ref.read(authRepositoryProvider).login(email, password));

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) =>
      _authenticate(() => ref.read(authRepositoryProvider).register(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ));

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } on ApiException {
      // Sunucuya ulaşılamasa da yerel oturumu kapat.
    }
    await ref.read(tokenStorageProvider).clear();
    state = const AsyncData(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);
