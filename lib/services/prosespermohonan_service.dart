import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/dio_exception_parse.dart';
import 'package:newklikrkw/models/itememprosesperm.dart';
import 'package:newklikrkw/models/prosespermohonan.dart';
import 'package:newklikrkw/models/statusprosesperm.dart';
import 'package:newklikrkw/models/store_prosespermohonan_request.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class ProsespermohonanService {
  ProsespermohonanService();

  Future<List<Prosespermohonan>> getData({
    required int offset,
    required int limit,
    String? transpermohonanId,
    String query = '',
    int? statusProsespermId,
    int? itemProsespermId,
    int? userId,
    bool? isTranspermohonanId,
  }) async {
    final token = await getToken();
    final response = await dio.get(
      '/prosespermohonans',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        responseType: ResponseType.json,
      ),
      queryParameters: {
        'transpermohonan_id': ?transpermohonanId,
        'user_id': ?userId,
        'statusprosesperm_id': ?statusProsespermId,
        'itemprosesperm_id': ?itemProsespermId,
        'is_transpermohonan_id': ?isTranspermohonanId,
        'offset': offset,
        'limit': limit,
        'query': query,
      },
    );

    return (response.data['data'] as List)
        .map((e) => Prosespermohonan.fromJson(e))
        .toList();
  }

  Future<List<Statusprosesperm>> getStatusprosespermOptions() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/prosespermohonans/statusprosespems/options',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => Statusprosesperm.fromJson(e)).toList();
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
    // } on DioException catch (e) {
    //   throw Exception(
    //     e.response?.data.toString() ??
    //         e.message ??
    //         'Gagal mengambil opsi status permohonan',
    //   );
    // }
  }

  Future<List<Itemprosesperm>> getItemprosespermOptions() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/prosespermohonans/itemprosesperms/options',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final List<dynamic> data = response.data['data'];
      return data.map((e) => Itemprosesperm.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status permohonan',
      );
    }
  }

  Future<void> store(StoreProsespermohonanrequest request) async {
    try {
      String? token = await getToken();
      await dio.post(
        '/prosespermohonans/store',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  Future<void> update(StoreProsespermohonanrequest request) async {
    try {
      String? token = await getToken();
      await dio.post(
        '/prosespermohonans/${request.id}/update',
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }
}
