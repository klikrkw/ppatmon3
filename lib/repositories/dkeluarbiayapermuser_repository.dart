import 'package:newklikrkw/models/add_dkeluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/services/dkeluarbiayapermuser_service.dart';

class DkeluarbiayapermuserRepository {
  final DkeluarbiayapermuserService service;

  const DkeluarbiayapermuserRepository({required this.service});

  ///==========================================
  /// LIST DETAIL KELUAR BIAYA
  ///==========================================
  Future<Map<String, dynamic>> getDkeluarbiayapermusers({
    String? keluarbiayapermuserId,
    String? transpermohonanId,
    int offset = 0,
    int limit = 20,
  }) {
    return service.getDkeluarbiayapermusers(
      keluarbiayapermuserId: keluarbiayapermuserId,
      transpermohonanId: transpermohonanId,
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

  Future<void> addDkeluarbiayapermuser(
    String keluarbiayapermuserId,
    AddDKeluarbiayapermuserRequest request,
  ) {
    return service.addDkeluarbiayapermuser(keluarbiayapermuserId, request);
  }

  Future<void> updateDkeluarbiayapermuser(
    String id,
    AddDKeluarbiayapermuserRequest request,
  ) {
    return service.updateDkeluarbiayapermuser(id, request);
  }

  Future<Keluarbiayapermuser> getKeluarbiayapermuser({
    required String keluarbiayapermuserId,
  }) {
    return service.getKeluarbiayapermuser(
      keluarbiayapermuserId: keluarbiayapermuserId,
    );
  }

  Future<void> updateStatusKeluarbiayapermuser({
    required String keluarbiayapermuserId,
    required String status,
  }) {
    return service.updateStatusKeluarbiayapermuser(
      keluarbiayapermuserId: keluarbiayapermuserId,
      status: status,
    );
  }

  Future<void> deleteDkeluarbiayapermuser(String id) {
    return service.deleteDkeluarbiayapermuser(id);
  }
}
