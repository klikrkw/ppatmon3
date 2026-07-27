import 'package:dio/dio.dart';
import 'package:newklikrkw/utils/auth.dart';
import '../models/jenishak.dart';
import '../utils/dio.dart';

class JenishakService {
  Future<List<Jenishak>> getAll({String query = ""}) async {
    try {
      String? token = await getToken();

      final response = await dio.get(
        "/jenishaks/list",
        queryParameters: {"query": query},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List list = response.data["data"];

      return list.map((e) => Jenishak.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }
}
