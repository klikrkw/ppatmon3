import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/dio_exception_parse.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class HomeService {
  HomeService();

  Future<Response> dashboard(int? userId) async {
    try {
      String? token = await getToken();
      return dio.get(
        "/dashboard/home",
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
        queryParameters: {"user_id": ?userId},
      );
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }
}
