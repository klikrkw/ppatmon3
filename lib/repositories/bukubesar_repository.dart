import 'package:newklikrkw/models/kode_akun.dart';
import 'package:newklikrkw/services/bukubesar_service.dart';

class BukubesarRepository {
  final BukubesarService service;

  BukubesarRepository({required this.service});

  Future<Map<String, dynamic>> getBukubesars({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    int? akunId,
  }) {
    return service.getBukubesars(
      offset: offset,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      akunId: akunId,
    );
  }

  Future<List<KodeAkun>> getKodeAkuns() {
    return service.getKodeAkuns();
  }
}
