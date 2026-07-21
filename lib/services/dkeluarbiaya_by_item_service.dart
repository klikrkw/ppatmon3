import 'package:dio/dio.dart';

import 'package:newklikrkw/models/dkeluarbiaya_by_item_response.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class DkeluarbiayaByItemService {
  Future<DkeluarbiayaByItemResponse> getDkeluarbiayas({
    required int offset,
    required int limit,
    int? itemkegiatanId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/dkeluarbiayas/by-item",
        queryParameters: {
          "offset": offset,
          "limit": limit,

          "itemkegiatan_id": ?itemkegiatanId,

          if (startDate != null) "start_date": _formatDate(startDate),

          if (endDate != null) "end_date": _formatDate(endDate),
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return DkeluarbiayaByItemResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  Future<List<Itemkegiatan>> getItemkegiatans() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/itemkegiatans/list",
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data["data"] as List;

      return data.map((e) => Itemkegiatan.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }
}
