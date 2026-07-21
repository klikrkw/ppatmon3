import 'package:dio/dio.dart';
import 'package:newklikrkw/models/bukubesar.dart';
import 'package:newklikrkw/models/kode_akun.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class BukubesarService {
  Future<Map<String, dynamic>> getBukubesars({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    int? akunId,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/lapkeuangans/bukubesar",
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (startDate != null) "start_date": startDate.toIso8601String(),
          if (endDate != null) "end_date": endDate.toIso8601String(),
          "akun_id": ?akunId,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data;

      return {
        "items": (data["data"] as List)
            .map((e) => Bukubesar.fromJson(e))
            .toList(),

        "pagination": data["pagination"],
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil data bukubesar',
      );
    }
  }

  Future<List<KodeAkun>> getKodeAkuns() async {
    try {
      String? token = await getToken();

      final response = await dio.get(
        "/lapkeuangans/akuns",
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return (response.data["data"] as List)
          .map((e) => KodeAkun.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil data akuns',
      );
    }
  }
}
