import 'package:dio/dio.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class TranspermohonanService {
  Future<List<Transpermohonan>> getPermohonan(
    String keyword,
    int? userId,
  ) async {
    final token = await getToken();
    try {
      final response = await dio.get(
        '/transpermohonans/list',
        queryParameters: {'search': keyword, 'user_id': ?userId},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
      );

      final List<dynamic> data = response.data['data'];

      return data.map((e) => Transpermohonan.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<List<Transpermohonan>> getTransPermohonan({
    required int offset,
    required int limit,
    String query = '',
    bool? active,
    int? userId,
    String? transpermohonanId,
    bool? isTranspermohonanId,
  }) async {
    try {
      final token = await getToken();
      final response = await dio.get(
        '/transpermohonans/getlist',
        queryParameters: {
          'query': query,
          'user_id': ?userId,
          'transpermohonan_id': ?transpermohonanId,
          'offset': offset,
          'limit': limit,
          'active': ?active,
          'is_transpermohonan_id': ?isTranspermohonanId,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
      );
      final List<dynamic> data = response.data['data'];

      return data.map((e) => Transpermohonan.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateStatusPermohonan({
    required String id,
    required bool active,
  }) async {
    final token = await getToken();
    await dio.put(
      '/transpermohonans/permohonan/status/$id/update',
      data: {'active': active},
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
      ),
    );
  }
}
