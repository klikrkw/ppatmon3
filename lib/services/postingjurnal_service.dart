import 'package:dio/dio.dart';
import 'package:newklikrkw/models/postingjurnal_response.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class PostingjurnalService {
  Future<PostingjurnalResponse> getPostingjurnals({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String? token = await getToken();

      final response = await dio.get(
        "/postingjurnals",
        queryParameters: {
          "offset": offset,
          "limit": limit,

          if (startDate != null) "start_date": startDate.toIso8601String(),

          if (endDate != null) "end_date": endDate.toIso8601String(),
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return PostingjurnalResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Response> getAkuns() async {
    try {
      String? token = await getToken();
      return dio.get(
        '/lapkeuangans/akuns',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Response> create(FormData data) async {
    try {
      String? token = await getToken();
      return dio.post(
        '/postingjurnals/add',
        data: data,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Response> update(String id, FormData data) async {
    try {
      String? token = await getToken();
      return dio.post(
        '/postingjurnals/$id/update',
        data: data,
        // queryParameters: {'_method': 'POST'},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Response> delete(String id) async {
    try {
      String? token = await getToken();
      return dio.delete(
        '/postingjurnals/$id/delete',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }
}
