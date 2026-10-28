import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.fieldErrors = const {}});

  final String message;
  final int? statusCode;
  final Map<String, List<String>> fieldErrors;

  bool get isUnauthenticated => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (status == null) {
      return ApiException('Sunucuya ulaşılamadı. Bağlantınızı kontrol edin.');
    }
    if (status == 429) {
      return ApiException('Çok fazla istek. Lütfen biraz bekleyin.',
          statusCode: status);
    }
    if (status == 404) {
      return ApiException('Kayıt bulunamadı.', statusCode: status);
    }

    var message = 'Bir hata oluştu.';
    final fields = <String, List<String>>{};
    if (data is Map) {
      if (data['message'] is String) message = data['message'] as String;
      final errors = data['errors'];
      if (errors is Map) {
        errors.forEach((k, v) {
          if (v is List) fields[k.toString()] = v.map((e) => '$e').toList();
        });
        if (fields.isNotEmpty) message = fields.values.first.first;
      }
    }
    return ApiException(message, statusCode: status, fieldErrors: fields);
  }

  @override
  String toString() => message;
}
