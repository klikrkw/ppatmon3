import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';

class TranspermohonanRepository {
  final TranspermohonanService service;

  TranspermohonanRepository(this.service);

  Future<List<Transpermohonan>> search(String keyword, int? userId) {
    return service.getPermohonan(keyword, userId);
  }

  Future<List<Transpermohonan>> getData({
    required int offset,
    required int limit,
    String query = '',
    int? userId,
    bool? active,
    String? transpermohonanId,
    bool isTranspermohonanId = false,
  }) {
    return service.getTransPermohonan(
      offset: offset,
      limit: limit,
      query: query,
      active: active,
      userId: userId,
      transpermohonanId: transpermohonanId,
      isTranspermohonanId: isTranspermohonanId,
    );
  }

  Future<void> updateStatusPermohonan({
    required String id,
    required bool active,
  }) {
    return service.updateStatusPermohonan(id: id, active: active);
  }
}
