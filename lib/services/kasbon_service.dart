import 'package:dio/dio.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/models/dkasbon.dart';
import 'package:newklikrkw/models/dkasbonnoperm.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:searchable_select_internal/searchable_select_internal.dart';
import 'package:newklikrkw/utils/dio.dart';

class KasbonService {
  Future<PagedResult<Kasbon>> list({
    required String keyword,
    String? statusKasbon,
    String? userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    String? token = await getToken();
    if (token == null) {
      return PagedResult<Kasbon>(data: [], hasMore: false);
    }
    try {
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
          if (userId != null && userId.isNotEmpty) 'user_id': userId,
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
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal update status');
    }
  }

  Future<void> updateStatusKasbon({
    required String id,
    required String statusKasbon,
  }) async {
    try {
      String? token = await getToken();
      await dio.patch(
        '/kasbons/$id/update_status',
        data: {'status_kasbon': statusKasbon},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Gagal update status');
    }
  }

  Future<List<DbOption>> getStatusKasbonOptions() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/kasbons/statuskasbonoptions',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => DbOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }

  Future<List<DbOption>> getInstansiOptions() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/instansis/listoptions',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => DbOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }

  Future<double> getTotalKasbon(int? userId) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/kasbons/total_kasbon',
        queryParameters: {'user_id': userId},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final dynamic data = response.data['data'];
      return double.parse(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi total kasbon',
      );
    }
  }

  Future<Kasbon> createKasbon({required AddKasbonRequest request}) async {
    try {
      String? token = await getToken();
      final response = await dio.post(
        '/kasbons/store',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Kasbon.fromJson(response.data['data']);
    } on DioException catch (e) {
      // return e.response?.data['message'] ?? 'Gagal menambah kasbon';
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah kasbon');
    }
  }

  Future<Kasbon> updateKasbon({
    required UpdateKasbonRequest request,
    required String id,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.patch(
        '/kasbons/$id/update',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Kasbon.fromJson(response.data['data']);
    } on DioException catch (e) {
      // return e.response?.data['message'] ?? 'Gagal menambah kasbon';
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah kasbon');
    }
  }

  Future<Kasbon> updateKasbonPerm({
    required UpdateKasbonPermRequest request,
    required String id,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.patch(
        '/kasbons/$id/update',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Kasbon.fromJson(response.data['data']);
    } on DioException catch (e) {
      // return e.response?.data['message'] ?? 'Gagal menambah kasbon';
      throw Exception(e.response?.data['message'] ?? 'Gagal menambah kasbon');
    }
  }

  List<String> getJenisKasbonOptions() {
    final List<String> jenisKabonOptions = ['permohonan', 'non_permohonan'];
    return jenisKabonOptions;
  }

  Future<Map<String, dynamic>> getDKasbonNoPerms({
    required String kasbonId,
    required int page,
  }) async {
    String? token = await getToken();
    final response = await dio.get(
      '/kasbons/dkasbonnoperms',
      queryParameters: {'kasbon_id': kasbonId, 'page': page},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final json = response.data;

    return {
      'data': (json['data'] as List)
          .map((e) => Dkasbonnoperm.fromJson(e))
          .toList(),
      'hasMore': json['next_page_url'] != null,
    };
  }

  Future<Map<String, dynamic>> getDKasbons({
    required String kasbonId,
    required int page,
  }) async {
    String? token = await getToken();
    final response = await dio.get(
      '/kasbons/dkasbons',
      queryParameters: {'kasbon_id': kasbonId, 'page': page},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final json = response.data;
    return {
      'data': (json['data'] as List).map((e) => Dkasbon.fromJson(e)).toList(),
      'hasMore': json['next_page_url'] != null,
    };
  }
}
