import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/utils/dio.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';

class KasbonRepository {
  KasbonRepository();

  static Future<PagedResult<Kasbon>> list({
    required String keyword,
    String? statusKasbon,
    int page = 1,
    int pageSize = 10,
  }) async {
    final storage = const FlutterSecureStorage();
    final String tokenKey = 'auth_token';
    String? token = await storage.read(key: tokenKey);
    if (token == null) {
      return PagedResult<Kasbon>(data: [], hasMore: false);
    }
    final response = await dio.get(
      '/kasbons',
      queryParameters: {
        'search': keyword,
        'page': page,
        'pageSize': pageSize,
        if (statusKasbon != null &&
            statusKasbon.isNotEmpty &&
            statusKasbon != 'semua')
          'status_kasbon': statusKasbon,
      },
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final items = (response.data['data'] as List)
        .map((e) => Kasbon.fromJson(e))
        .toList();

    final total = response.data['total'];

    return PagedResult<Kasbon>(data: items, hasMore: page * pageSize < total);
  }

  static Future<void> updateStatusKasbon({
    required String id,
    required String statusKasbon,
  }) async {
    try {
      await dio.put(
        '/kasbons/$id/status',
        data: {'status_kasbon': statusKasbon},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal update status');
    }
  }

  static Future<List<String>> getStatusKasbonOptions() async {
    try {
      final response = await dio.get('/status-kasbon-options');
      return List<String>.from(response.data['data'] ?? []);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }
}
