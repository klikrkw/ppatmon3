import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/api_exception.dart';
import 'package:newklikrkw/utils/dio.dart';

class AuthService {
  // final Dio _dio = Dio(
  //   BaseOptions(
  //     // Gunakan 10.0.2.2 untuk Android Emulator, 127.0.0.1 untuk iOS
  //     baseUrl: Platform.isAndroid
  //         ? 'http://10.0.2.2:8000/api/v1'
  //         : 'http://127.0.0.1:8000/api/v1',
  //     connectTimeout: const Duration(seconds: 5),
  //     receiveTimeout: const Duration(seconds: 3),
  //   ),
  // );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
        options: Options(responseType: ResponseType.json),
      );

      return response.data;
    } on DioException catch (e) {
      // return e.response?.data;
      throw Exception(
        e.response?.data['message'] ?? 'Gagal terhubung ke server',
      );
    }
  }

  Future<Map<String, dynamic>> getUser(String token) async {
    try {
      final response = await dio.get(
        '/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException(e.response?.data['message']);
      // throw Exception(
      //   e.response?.data['message'] ?? 'error getUser : gagal login to server',
      // );
    }
  }

  Future<List<dynamic>> getUsers(String token) async {
    try {
      final response = await dio.get(
        '/users/list',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.json,
        ),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw ApiException(e.response?.data['message']);
    }
  }

  Future<void> logout(String token) async {
    try {
      await dio.post(
        '/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw Exception('Gagal logout dari server');
    }
  }
}
