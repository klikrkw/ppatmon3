import 'dart:io';

import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/api_exception.dart';
import 'package:newklikrkw/models/akun.dart';
import 'package:newklikrkw/models/postingjurnal.dart';
import 'package:newklikrkw/models/postingjurnal_response.dart';
import 'package:newklikrkw/models/requests/add_postingjurnal_request.dart';
import 'package:newklikrkw/models/requests/update_postingjurnal_request.dart';
import 'package:newklikrkw/models/validation_error.dart';
import 'package:newklikrkw/models/validation_exception.dart';
import 'package:newklikrkw/services/postingjurnal_service.dart';

class PostingjurnalRepository {
  final PostingjurnalService service;

  PostingjurnalRepository({required this.service});

  Future<PostingjurnalResponse> getPostingjurnals({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return service.getPostingjurnals(
      offset: offset,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
    );
  }
  //==================================================
  // AKUN
  //==================================================

  Future<List<Akun>> getAkuns() async {
    try {
      final response = await service.getAkuns();

      return (response.data['data'] as List)
          .map((e) => Akun.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //==================================================
  // CREATE
  //==================================================

  Future<Postingjurnal> create(AddPostingjurnalRequest request) async {
    try {
      final formData = await _createFormData(
        request.uraian,
        request.akunDebet,
        request.akunKredit,
        request.jumlah,
        request.imageFile,
      );

      final response = await service.create(formData);

      return Postingjurnal.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //==================================================
  // UPDATE
  //==================================================

  Future<Postingjurnal> update(
    String id,

    UpdatePostingjurnalRequest request,
  ) async {
    try {
      final formData = await _createFormData(
        request.uraian,

        request.akunDebet,

        request.akunKredit,

        request.jumlah,

        request.imageFile,
      );

      final response = await service.update(id, formData);

      return Postingjurnal.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //==================================================
  // DELETE
  //==================================================

  Future<void> delete(String id) async {
    try {
      await service.delete(id);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  //==================================================
  // FORM DATA
  //==================================================

  Future<FormData> _createFormData(
    String uraian,

    int akunDebet,

    int akunKredit,

    double jumlah,

    File? image,
  ) async {
    return FormData.fromMap({
      'uraian': uraian,

      'akun_debet': akunDebet,

      'akun_kredit': akunKredit,

      'jumlah': jumlah,

      if (image != null)
        'image_file': await MultipartFile.fromFile(
          image.path,

          filename: image.path.split('/').last,
        ),
    });
  }

  //==================================================
  // ERROR HANDLER
  //==================================================

  Exception _handleError(DioException e) {
    final data = e.response?.data;

    if (e.response?.statusCode == 422 && data is Map) {
      return ValidationException(ValidationError.fromJson(data['errors']));
    }

    return ApiException(
      data is Map
          ? data['message'] ?? 'Terjadi kesalahan'
          : e.message ?? 'Network error',
    );
  }
}
