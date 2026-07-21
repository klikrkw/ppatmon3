import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/api_validation_exception.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/add_dkeluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/dkeluarbiayapermuser.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/utils.dart';

class DkeluarbiayapermuserService {
  DkeluarbiayapermuserService();

  ///==========================================
  /// GET DETAIL KELUAR BIAYA
  ///==========================================
  Future<Map<String, dynamic>> getDkeluarbiayapermusers({
    String? keluarbiayapermuserId,
    String? transpermohonanId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/dkeluarbiayapermusers/list",
        queryParameters: {
          "keluarbiayapermuser_id": ?keluarbiayapermuserId,
          "transpermohonan_id": ?transpermohonanId,
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
            .map((e) => Dkeluarbiayapermuser.fromJson(e))
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

  Future<Keluarbiayapermuser> getKeluarbiayapermuser({
    required String keluarbiayapermuserId,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/keluarbiayapermusers/$keluarbiayapermuserId/show",
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data["data"];

      return Keluarbiayapermuser.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<void> addDkeluarbiayapermuser(
    String keluarbiayapermuserId,
    AddDKeluarbiayapermuserRequest request,
  ) async {
    final formData = FormData.fromMap({
      "transpermohonan_Id": request.keluarbiayapermuserId,
      "transpermohonan_id": request.transpermohonanId,
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
        "/dkeluarbiayapermusers/$keluarbiayapermuserId/add",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      print(e.response?.data);
      if (e.response?.statusCode == 422) {
        throw ApiValidationExtException.fromJson(e.response!.data);
      }
      rethrow;
    }
  }

  Future<void> updateDkeluarbiayapermuser(
    String id,
    AddDKeluarbiayapermuserRequest request,
  ) async {
    final formData = FormData.fromMap({
      "_method": "PUT",

      "keluarbiayapermuser_id": request.keluarbiayapermuserId,
      "transpermohonan_id": request.transpermohonanId,
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
      await dio.post("/dkeluarbiayapermusers/$id", data: formData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiValidationExtException.fromJson(e.response!.data);
      }

      rethrow;
    }
  }

  Future<void> updateStatusKeluarbiayapermuser({
    required String keluarbiayapermuserId,
    required String status,
  }) async {
    try {
      String? token = await getToken();
      await dio.put(
        "/keluarbiayapermusers/$keluarbiayapermuserId/updatestatus",
        data: {"status_keluarbiayapermuser": status},
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

  Future<void> deleteDkeluarbiayapermuser(String id) async {
    try {
      String? token = await getToken();
      await dio.delete(
        "/dkeluarbiayapermusers/$id",
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
