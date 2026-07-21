import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/add_keluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class KeluarbiayapermuserService {
  KeluarbiayapermuserService();

  Future<Map<String, dynamic>> getKeluarbiayapermusers({
    int offset = 0,
    int limit = 20,
    int? userId,
    String? status,
  }) async {
    String? token = await getToken();
    try {
      final response = await dio.get(
        "/keluarbiayapermusers",
        queryParameters: {
          "offset": offset,
          "limit": limit,
          "user_id": ?userId,
          if (status != null && status.isNotEmpty)
            "status_keluarbiayapermuser": status,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data as Map<String, dynamic>;

      final items = (data["data"] as List)
          .map((e) => Keluarbiayapermuser.fromJson(e))
          .toList();

      final pagination = data["pagination"];

      return {
        "items": items,
        "offset": pagination["offset"],
        "limit": pagination["limit"],
        "total": pagination["total"],
        "hasMore": pagination["has_more"],
      };
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }

  Future<List<User>> getUsers() async {
    final response = await dio.get("/users");

    return (response.data["data"] as List)
        .map((e) => User.fromJson(e))
        .toList();
  }

  Future<List<String>> getStatusKeluarbiayapermusers() async {
    String? token = await getToken();
    final response = await dio.get(
      "/keluarbiayapermusers/statuskeluarbiayapermusers",
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return List<String>.from(response.data["data"]);
  }

  Future<void> addKeluarbiayapermuser(
    AddKeluarbiayapermuserRequest request,
  ) async {
    try {
      String? token = await getToken();
      await dio.post(
        "/keluarbiayapermusers/store",
        data: request.toMap(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw ApiValidationExtException.fromJson(e.response!.data);
      }

      rethrow;
    }
  }

  Future<List<Metodebayar>> getMetodebayars() async {
    String? token = await getToken();
    final response = await dio.get(
      "/keluarbiayapermusers/metodebayars",
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return (response.data["data"] as List)
        .map((e) => Metodebayar.fromJson(e))
        .toList();
  }

  Future<List<Rekening>> getRekenings({int? metodebayarId}) async {
    String? token = await getToken();
    final response = await dio.get(
      "/keluarbiayapermusers/rekenings",
      queryParameters: {"metodebayar_id": ?metodebayarId},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return (response.data["data"] as List)
        .map((e) => Rekening.fromJson(e))
        .toList();
  }

  Future<List<Instansi>> getInstansis({String? kasbonId}) async {
    String? token = await getToken();
    final response = await dio.get(
      "/keluarbiayapermusers/instansis",
      queryParameters: {"kasbon_id": ?kasbonId},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    return (response.data["data"] as List)
        .map((e) => Instansi.fromJson(e))
        .toList();
  }

  Future<List<Kasbon>> getKasbons({int? userId}) async {
    String? token = await getToken();
    final response = await dio.get(
      "/keluarbiayapermusers/kasbons",
      queryParameters: {"user_id": ?userId},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return (response.data["data"] as List)
        .map((e) => Kasbon.fromJson(e))
        .toList();
  }
}
