import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newklikrkw/models/catatanperm.dart';
import 'package:newklikrkw/models/catatanperm_response.dart';
import 'package:newklikrkw/models/fieldcatatan.dart';
import 'package:newklikrkw/models/requests/add_edit_catatanperm_request.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class CatatanpermService {
  Future<CatatanpermResponse> getCatatanperms({
    String? transpermohonanId,
    int offset = 0,
    int limit = 20,
    int? fieldcatatanId,
    String? keyword,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String? token = await getToken();

      final queryParameters = <String, dynamic>{
        'offset': offset,
        'limit': limit,
      };
      if (transpermohonanId != null && transpermohonanId.isNotEmpty) {
        queryParameters['transpermohonan_id'] = transpermohonanId;
      }

      if (fieldcatatanId != null) {
        queryParameters['fieldcatatan_id'] = fieldcatatanId;
      }

      if (keyword != null && keyword.trim().isNotEmpty) {
        queryParameters['isi_catatan'] = keyword.trim();
      }

      if (startDate != null) {
        queryParameters['start_date'] = _formatDate(startDate);
      }

      if (endDate != null) {
        queryParameters['end_date'] = _formatDate(endDate);
      }
      final response = await dio.get(
        '/catatanperms/list',
        queryParameters: queryParameters,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return CatatanpermResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }

  Future<List<Fieldcatatan>> getFieldcatatans() async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/catatanperms/fieldcatatans',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final data = response.data['data'] as List;

      return data
          .map((json) => Fieldcatatan.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Catatanperm> add(AddEditCatatanpermRequest request) async {
    try {
      String? token = await getToken();

      final formData = await _buildFormData(request);

      final response = await dio.post(
        '/catatanperms/add',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Catatanperm.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<Catatanperm> update(int id, AddEditCatatanpermRequest request) async {
    try {
      String? token = await getToken();
      final formData = await _buildFormData(request);

      final response = await dio.post(
        '/catatanperms/$id/update',
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return Catatanperm.fromJson(response.data['data']);
    } on DioException catch (e) {
      print('error : $e');

      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<void> delete(int id) async {
    try {
      String? token = await getToken();
      await dio.delete(
        '/catatanperms/$id/delete',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? e.message ?? 'Gagal mengambil data',
      );
    }
  }

  Future<FormData> _buildFormData(AddEditCatatanpermRequest request) async {
    final Map<String, dynamic> data = {
      'isi_catatanperm': request.isiCatatanperm,
      'fieldcatatan_id': request.fieldcatatanId,
      'transpermohonan_id': request.transpermohonanId,
      'user_id': request.userId,
    };

    if (request.imageFile != null) {
      data['image_file'] = await MultipartFile.fromFile(
        request.imageFile!.path,
        filename: _fileName(request.imageFile!),
      );
    }

    return FormData.fromMap(data);
  }

  String _fileName(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }
}
