import 'package:dio/dio.dart';

import '../core/api_exception.dart';
import '../models/todo.dart';

class TodoRepository {
  TodoRepository(this._dio);
  final Dio _dio;

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<List<Todo>> list({TodoStatus? status}) => _guard(() async {
        final res = await _dio.get('/todos',
            queryParameters: {if (status != null) 'status': status.value});
        return (res.data as List)
            .map((e) => Todo.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  Future<Todo> create(TodoPayload payload) => _guard(() async {
        final res = await _dio.post('/todos', data: payload.toJson());
        return Todo.fromJson(res.data as Map<String, dynamic>);
      });

  Future<Todo> update(int id, TodoPayload payload) => _guard(() async {
        final res = await _dio.patch('/todos/$id', data: payload.toJson());
        return Todo.fromJson(res.data as Map<String, dynamic>);
      });

  Future<void> delete(int id) => _guard(() => _dio.delete('/todos/$id'));
}
