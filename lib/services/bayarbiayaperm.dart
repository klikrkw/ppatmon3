import 'package:dio/dio.dart';
import 'package:newklikrkw/core/helpers/dio_exception_parse.dart';
import 'package:newklikrkw/models/add_bayarbiayaperm_request.dart';
import 'package:newklikrkw/models/bayarbiayaperm.dart';
import 'package:newklikrkw/models/bayarbiayaperm_response.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/utils/auth.dart';
import 'package:newklikrkw/utils/utils.dart';

class BayarbiayapermService {
  BayarbiayapermService();

  /// Infinite List
  Future<List<Bayarbiayaperm>> getBayarbiayaperms({
    int offset = 0,
    int limit = 20,
    String? query,
    String? biayapermId,
  }) async {
    try {
      String? token = await getToken();
      final response = await dio.get(
        "/bayarbiayaperms/list",
        queryParameters: {
          "offset": offset,
          "limit": limit,
          if (query != null && query.isNotEmpty) "query": query,
          if (biayapermId != null && biayapermId.isNotEmpty)
            "biayaperm_id": biayapermId,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      final result = BayarbiayapermResponse.fromJson(response.data);

      return result.data;
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  /// Detail
  Future<Bayarbiayaperm> getDetail(String id) async {
    final response = await dio.get("/bayarbiayaperm/$id");

    return Bayarbiayaperm.fromJson(response.data["data"]);
  }

  Future<void> add(AddBayarbiayapermRequest request) async {
    try {
      String? token = await getToken();
      final formData = FormData.fromMap({
        'biayaperm_id': request.biayapermId,
        'metodebayar_id': request.metodebayarId,
        'rekening_id': request.rekeningId,
        'jumlah_bayar': request.jumlahBayar,
        'saldo_awal': request.saldoAwal,
        'saldo_akhir': request.saldoAkhir,
        'catatan_bayarbiayaperm': request.catatanBayarbiayaperm,
        if (request.imageFile != null)
          'image_file': await MultipartFile.fromFile(
            request.imageFile!.path,
            filename: request.imageFile!.path.split('/').last,
          ),
      });

      await dio.post(
        "/bayarbiayaperms/store",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  Future<void> update(String id, AddBayarbiayapermRequest request) async {
    try {
      final formData = FormData.fromMap({
        '_method': 'PUT',

        'biayaperm_id': request.biayapermId,

        'metodebayar_id': request.metodebayarId,

        'rekening_id': request.rekeningId,

        'jumlah_bayar': request.jumlahBayar,
        'saldo_akhir': request.saldoAkhir,
        'saldo_awal': request.saldoAwal,

        'catatan_bayarbiayaperm': request.catatanBayarbiayaperm,

        if (request.imageFile != null)
          'image_bayarbiayaperm': await MultipartFile.fromFile(
            request.imageFile!.path,
            filename: request.imageFile!.path.split('/').last,
          ),
      });

      String? token = await getToken();

      await dio.post(
        "/bayarbiayaperm/$id",
        data: formData,
        options: Options(
          responseType: ResponseType.json,
          contentType: 'multipart/form-data',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioException catch (e) {
      throw DioExceptionParser.parse(e);
    }
  }

  /// Delete
  Future<void> delete(String id) async {
    await dio.delete("/bayarbiayaperms/$id");
  }

  /// ===============================
  /// Metode Pembayaran
  /// ===============================
  Future<List<Metodebayar>> getMetodebayars() async {
    String? token = await getToken();
    final response = await dio.get(
      "/bayarbiayaperms/metodebayars",
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List list = response.data["data"];

    return list.map((e) => Metodebayar.fromJson(e)).toList();
  }

  /// ===============================
  /// Rekening
  /// ===============================
  Future<List<Rekening>> getRekenings({int? metodebayarId}) async {
    String? token = await getToken();
    final response = await dio.get(
      "/bayarbiayaperms/rekenings",
      queryParameters: {"metodebayar_id": ?metodebayarId},
      options: Options(
        responseType: ResponseType.json,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final List list = response.data["data"];

    return list.map((e) => Rekening.fromJson(e)).toList();
  }
}
