import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/dio_exception_parse.dart';
import 'package:newklikrkw/models/berkas_lokasi_reponse.dart';
import 'package:newklikrkw/models/tempatberkas.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class BerkasLokasiService {
  BerkasLokasiService();

  Future<BerkasLokasiResponse> getLokasiBerkas(String transpermohonanId) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/lokasi-berkas/$transpermohonanId',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return BerkasLokasiResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  Future<List<Tempatberkas>> getTempatberkases() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/lokasi-berkas/tempatberkases/list',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => Tempatberkas.fromJson(e)).toList();
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  Future<Map<String, dynamic>> updatePosisiBerkas({
    required String transpermohonanId,
    required int tempatberkasId,
    required int row,
    required int col,
  }) async {
    String? token = await getToken();

    try {
      final response = await dio.post(
        '/lokasi-berkas/posisiberkas/$transpermohonanId/update',
        data: {'tempatberkas_id': tempatberkasId, 'row': row, 'col': col},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }
}
