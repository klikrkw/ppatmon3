import 'package:dio/dio.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/models/add_biayaperm_request.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/models/rincianbiayaperm.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/dio.dart';

class BiayapermService {
  BiayapermService();

  Future<List<Biayaperm>> getBiayaperms({
    required int offset,
    required int limit,
    String? transpermohonanId,
    bool isTranspermohonanId = false,
    StatusBiayas? statusBiayaperm,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/biayaperms/list',
        queryParameters: {
          'offset': offset,
          'limit': limit,
          'transpermohonan_id': transpermohonanId,
          'is_transpermohonan_id': isTranspermohonanId,
          'status_biayaperm': statusBiayaperm?.name,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final List data = response.data['data'];

      return data.map((e) => Biayaperm.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }

  Future<List<Rincianbiayaperm>> getRincianBiayaperm(
    String transpermohonanId,
  ) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/rincianbiayaperms/list',
        queryParameters: {'transpermohonan_id': transpermohonanId},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return (response.data['data'] as List)
          .map((e) => Rincianbiayaperm.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi status kasbon',
      );
    }
  }

  Future<Biayaperm> getBiayaperm(String biayapermId) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        '/biayaperms/$biayapermId/show',
        // queryParameters: {'biayaperm_id': biayapermId},
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return Biayaperm.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil opsi biaya permohonan',
      );
    }
  }

  Future<void> addBiayaperm(AddBiayapermRequest request) async {
    final formData = FormData.fromMap({
      'transpermohonan_id': request.transpermohonanId,

      'jumlah_biayaperm': request.jumlahBiayaperm,

      'jumlah_bayar': request.jumlahBayar,

      'kurang_bayar': request.kurangBayar,
      'jumlah_keluar': request.jumlahKeluar,

      'catatan_biayaperm': request.catatanBiayaperm,

      'rincianbiayaperm_id': request.rincianbiayapermId,

      if (request.imageFile != null)
        'image_file': await MultipartFile.fromFile(
          request.imageFile!.path,
          filename: request.imageFile!.path.split("/").last,
        ),
    });
    try {
      String? token = await getToken();
      await dio.post(
        "/biayaperms/store",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          contentType: "multipart/form-data",
        ),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ??
            e.message ??
            'Gagal mengambil store biayaperm',
      );
    }
  }

  //------------------------------------------------------
  // UPDATE
  //------------------------------------------------------

  Future<void> updateBiayaperm(String id, AddBiayapermRequest request) async {
    final formData = FormData.fromMap({
      'transpermohonan_id': request.transpermohonanId,

      'jumlah_biayaperm': request.jumlahBiayaperm,

      'jumlah_bayar': request.jumlahBayar,

      'kurang_bayar': request.kurangBayar,

      'catatan_biayaperm': request.catatanBiayaperm,

      'rincianbiayaperm_id': request.rincianbiayapermId,

      if (request.imageFile != null)
        'image_biayaperm': await MultipartFile.fromFile(
          request.imageFile!.path,
          filename: request.imageFile!.path.split("/").last,
        ),
    });

    await dio.post(
      "/biayaperm/$id",
      data: formData,
      options: Options(method: "PUT", contentType: "multipart/form-data"),
    );
  }
}
