import 'package:dio/dio.dart';
import 'package:newklikrkw/models/neraca_response.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class NeracaService {
  Future<NeracaResponse> getNeraca({required int year}) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/lapkeuangans/neraca",
        queryParameters: {"year": year},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return NeracaResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil data neraca',
      );
    }
  }

  Future<NeracaResponse> getNeracaPermohonan({
    required String transpermohonanId,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/lapkeuangans/neraca_permohonan",
        queryParameters: {"transpermohonan_id": transpermohonanId},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return NeracaResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil data neraca',
      );
    }
  }
}
