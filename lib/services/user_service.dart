import 'package:dio/dio.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/utils.dart';

class UserService {
  Future<List<DbOption>> getUserOptions() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/users/listoptions',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => DbOption.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil opsi user',
      );
    }
  }
}
