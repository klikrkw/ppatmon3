import 'package:dio/dio.dart';
import 'package:newklikrkw/models/validation_error.dart';
import 'package:newklikrkw/models/validation_exception.dart';

class DioExceptionParser {
  static Exception parse(DioException e) {
    if (e.response?.statusCode == 422) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return ValidationException(ValidationError.fromJson(data));
      }
    }

    if (e.type == DioExceptionType.connectionTimeout) {
      return Exception('Connection timeout');
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return Exception('Receive timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return Exception('Tidak dapat terhubung ke server');
    }

    return Exception(e.message ?? 'Terjadi kesalahan');
  }
}
