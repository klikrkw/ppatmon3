import 'package:dio/dio.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/utils.dart';

class ItemkegiatanService {
  Future<List<DbOption>> getOptions({int? instansiId}) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/itemkegiatans/listoptions',
        queryParameters: {'instansi_id': ?instansiId},
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
            'Gagal mengambil opsi itemkegiatan',
      );
    }
  }
}
