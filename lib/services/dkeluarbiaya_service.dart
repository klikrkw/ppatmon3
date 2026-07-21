import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/api_validation_exception.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/add_dkeluarbiaya_request.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiaya.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/utils.dart';

class DkeluarbiayaService {
  DkeluarbiayaService();

  ///==========================================
  /// GET DETAIL KELUAR BIAYA
  ///==========================================
  Future<Map<String, dynamic>> getDkeluarbiayas({
    required String keluarbiayaId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/dkeluarbiayas/list",
        queryParameters: {
          "keluarbiaya_id": keluarbiayaId,
          "offset": offset,
          "limit": limit,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final json = response.data;

      return {
        "items": (json["data"] as List)
            .map((e) => Dkeluarbiaya.fromJson(e))
            .toList(),

        "hasMore": json["pagination"]?["has_more"] ?? false,

        "total": json["pagination"]?["total"] ?? 0,

        "offset": json["pagination"]?["offset"] ?? offset,

        "limit": json["pagination"]?["limit"] ?? limit,
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  ///==========================================
  /// MASTER ITEM KEGIATAN
  ///==========================================
  Future<List<Itemkegiatan>> getItemkegiatans(int? instansiId) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/itemkegiatans/list",
        queryParameters: {"instansi_id": ?instansiId},
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

  Future<Keluarbiaya> getKeluarbiaya({required String keluarbiayaId}) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/keluarbiayas/$keluarbiayaId/show",
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data["data"];

      return Keluarbiaya.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<void> addDkeluarbiaya(
    String keluarbiayaId,
    AddDkeluarbiayaRequest request,
  ) async {
    final formData = FormData.fromMap({
      "keluarbiaya_id": request.keluarbiayaId,

      "itemkegiatan_id": request.itemkegiatanId,

      "jumlah_biaya": request.jumlahBiaya,

      "ket_biaya": request.ketBiaya,

      if (request.image != null)
        "image": await MultipartFile.fromFile(
          request.image!.path,
          filename: request.image!.name,
        ),
    });

    try {
      String? token = await getToken();
      await dio.post(
        "/dkeluarbiayas/$keluarbiayaId/add",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      // print(e.response?.data);
      if (e.response?.statusCode == 422) {
        throw ApiValidationExtException.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  Future<void> updateDkeluarbiaya(
    String id,
    AddDkeluarbiayaRequest request,
  ) async {
    final formData = FormData.fromMap({
      "_method": "PUT",

      "itemkegiatan_id": request.itemkegiatanId,

      "jumlah_biaya": request.jumlahBiaya,

      "ket_biaya": request.ketBiaya,

      if (request.image != null)
        "image": await MultipartFile.fromFile(
          request.image!.path,
          filename: request.image!.name,
        ),
    });

    try {
      await dio.post("/dkeluarbiayas/$id", data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiValidationExtException.fromJson(e.response!.data);
      }

      rethrow;
    }
  }

  Future<void> updateStatusKeluarbiaya({
    required String keluarbiayaId,
    required String status,
  }) async {
    try {
      String? token = await getToken();
      await dio.put(
        "/keluarbiayas/$keluarbiayaId/updatestatus",
        data: {"status_keluarbiaya": status},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiValidationException(
          message: e.response?.data['message'],
          validationError: e.response?.data['errors'],
        );
      }
    }
  }

  Future<void> deleteDkeluarbiaya(String id) async {
    try {
      String? token = await getToken();
      await dio.delete(
        "/dkeluarbiayas/$id",
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal delete data',
      );
    }
  }
}
