import 'package:newklikrkw/models/add_bayarbiayaperm_request.dart';
import 'package:newklikrkw/models/bayarbiayaperm.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/services/bayarbiayaperm.dart';

class BayarbiayapermRepository {
  final BayarbiayapermService service;

  const BayarbiayapermRepository({required this.service});

  /// Infinite List
  Future<List<Bayarbiayaperm>> getBayarbiayaperms({
    int offset = 0,
    int limit = 20,
    String? query,
    String? biayapermId,
  }) {
    return service.getBayarbiayaperms(
      offset: offset,
      limit: limit,
      query: query,
      biayapermId: biayapermId,
    );
  }

  /// Detail
  Future<Bayarbiayaperm> getDetail(String id) {
    return service.getDetail(id);
  }

  /// Add
  Future<void> add(AddBayarbiayapermRequest request) {
    return service.add(request);
  }

  /// Update
  Future<void> update(String id, AddBayarbiayapermRequest request) {
    return service.update(id, request);
  }

  /// ===============================
  /// Metode Pembayaran
  /// ===============================
  Future<List<Metodebayar>> getMetodebayars() {
    return service.getMetodebayars();
  }

  /// ===============================
  /// Rekening
  /// ===============================
  Future<List<Rekening>> getRekenings({int? metodebayarId}) {
    return service.getRekenings(metodebayarId: metodebayarId);
  }

  /// Delete
  Future<void> delete(String id) {
    return service.delete(id);
  }
}
