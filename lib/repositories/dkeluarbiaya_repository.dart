import 'package:newklikrkw/models/add_dkeluarbiaya_request.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiaya.dart';
import 'package:newklikrkw/services/dkeluarbiaya_service.dart';

class DkeluarbiayaRepository {
  final DkeluarbiayaService service;

  const DkeluarbiayaRepository({required this.service});

  ///==========================================
  /// LIST DETAIL KELUAR BIAYA
  ///==========================================
  Future<Map<String, dynamic>> getDkeluarbiayas({
    required String keluarbiayaId,
    int offset = 0,
    int limit = 20,
  }) {
    return service.getDkeluarbiayas(
      keluarbiayaId: keluarbiayaId,
      offset: offset,
      limit: limit,
    );
  }

  ///==========================================
  /// MASTER ITEM KEGIATAN
  ///==========================================
  Future<List<Itemkegiatan>> getItemkegiatans(int? instansiId) {
    return service.getItemkegiatans(instansiId);
  }

  Future<void> addDkeluarbiaya(
    String keluarbiayaId,
    AddDkeluarbiayaRequest request,
  ) {
    return service.addDkeluarbiaya(keluarbiayaId, request);
  }

  Future<void> updateDkeluarbiaya(String id, AddDkeluarbiayaRequest request) {
    return service.updateDkeluarbiaya(id, request);
  }

  Future<Keluarbiaya> getKeluarbiaya({required String keluarbiayaId}) {
    return service.getKeluarbiaya(keluarbiayaId: keluarbiayaId);
  }

  Future<void> updateStatusKeluarbiaya({
    required String keluarbiayaId,
    required String status,
  }) {
    return service.updateStatusKeluarbiaya(
      keluarbiayaId: keluarbiayaId,
      status: status,
    );
  }

  Future<void> deleteDkeluarbiaya(String id) {
    return service.deleteDkeluarbiaya(id);
  }
}
