import 'package:newklikrkw/models/dkeluarbiaya_by_item_response.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/services/dkeluarbiaya_by_item_service.dart';

class DkeluarbiayaByItemRepository {
  final DkeluarbiayaByItemService service;

  const DkeluarbiayaByItemRepository({required this.service});

  Future<DkeluarbiayaByItemResponse> getDkeluarbiayas({
    required int offset,
    required int limit,
    int? itemkegiatanId,
    DateTime? startDate,
    DateTime? endDate,
    String? keyword,
  }) {
    return service.getDkeluarbiayas(
      offset: offset,
      limit: limit,
      itemkegiatanId: itemkegiatanId,
      startDate: startDate,
      endDate: endDate,
      keyword: keyword,
    );
  }

  Future<List<Itemkegiatan>> getItemkegiatans({String? grup}) {
    return service.getItemkegiatans(grup: grup);
  }
}
