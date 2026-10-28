import 'package:dio/dio.dart';

import '../core/api_exception.dart';
import '../models/user.dart';

class AuthResult {
  const AuthResult(this.user, this.token);
  final User user;
  final String token;
}

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  AuthResult _parse(Map<String, dynamic> data) => AuthResult(
        User.fromJson(data['user'] as Map<String, dynamic>),
        data['token'] as String,
      );

  Future<AuthResult> login(String email, String password) => _guard(() async {
        final res = await _dio
            .post('/login', data: {'email': email, 'password': password});
        return _parse(res.data as Map<String, dynamic>);
      });

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) =>
      _guard(() async {
        final res = await _dio.post('/register', data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        });
        return _parse(res.data as Map<String, dynamic>);
      });

  Future<User> me() => _guard(() async {
        final res = await _dio.get('/user');
        return User.fromJson(res.data as Map<String, dynamic>);
      });

  Future<void> logout() => _guard(() => _dio.post('/logout'));
}
