import 'package:dio/dio.dart';
import 'package:newklikrkw/utils/auth.dart';

import '../models/jenispermohonan.dart';
import '../utils/dio.dart';

class JenispermohonanService {
  Future<List<Jenispermohonan>> getAll({String query = ""}) async {
    try {
      String? token = await getToken();

      final response = await dio.get(
        "/jenispermohonans/list",
        queryParameters: {"query": query},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List list = response.data["data"];

      return list.map((e) => Jenispermohonan.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }
}
