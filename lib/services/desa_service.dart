import 'package:dio/dio.dart';
import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class DesaService {
  Future<List<Desa>> getDesas({String? query}) async {
    try {
      String? token = await getToken();

      final response = await dio.get(
        '/desas/list',
        queryParameters: {
          if (query != null && query.isNotEmpty) 'query': query,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List list = response.data['data'];

      return list.map((e) => Desa.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }
}
