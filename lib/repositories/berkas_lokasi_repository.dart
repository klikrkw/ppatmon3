import 'package:newklikrkw/models/berkas_lokasi_reponse.dart';
import 'package:newklikrkw/models/tempatberkas.dart';
import 'package:newklikrkw/services/berkas_lokasi_service.dart';

class BerkasLokasiRepository {
  final BerkasLokasiService service;

  BerkasLokasiRepository(this.service);

  Future<BerkasLokasiResponse> getLokasiBerkas(String transpermohonanId) {
    return service.getLokasiBerkas(transpermohonanId);
  }

  Future<List<Tempatberkas>> getTempatberkases() {
    return service.getTempatberkases();
  }

  Future<Map<String, dynamic>> updatePosisiBerkas({
    required String transpermohonanId,
    required int tempatberkasId,
    required int row,
    required int col,
  }) async {
    return await service.updatePosisiBerkas(
      transpermohonanId: transpermohonanId,
      tempatberkasId: tempatberkasId,
      row: row,
      col: col,
    );
  }
}
