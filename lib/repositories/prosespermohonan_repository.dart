import 'package:newklikrkw/models/itememprosesperm.dart';
import 'package:newklikrkw/models/prosespermohonan.dart';
import 'package:newklikrkw/models/statusprosesperm.dart';
import 'package:newklikrkw/models/store_prosespermohonan_request.dart';
import 'package:newklikrkw/services/prosespermohonan_service.dart';

class ProsespermohonanRepository {
  final ProsespermohonanService service;

  ProsespermohonanRepository(this.service);

  Future<List<Prosespermohonan>> getData({
    String? transpermohonanId,
    int? statusProsespermId,
    int? itemProsespermId,
    required int offset,
    required int limit,
    bool? isTranspermohonanId,
    String query = '',
    int? userId,
  }) {
    return service.getData(
      transpermohonanId: transpermohonanId,
      statusProsespermId: statusProsespermId,
      itemProsespermId: itemProsespermId,
      offset: offset,
      limit: limit,
      query: query,
      isTranspermohonanId: isTranspermohonanId,
      userId: userId,
    );
  }

  Future<List<Statusprosesperm>> getStatusprosespermOptions() {
    return service.getStatusprosespermOptions();
  }

  Future<List<Itemprosesperm>> getItemprosespermOptions() {
    final result = service.getItemprosespermOptions();
    // debugPrint(result.toString());
    return result;
  }

  Future<void> store(StoreProsespermohonanrequest request) async {
    await service.store(request);
  }

  Future<void> update(StoreProsespermohonanrequest request) async {
    await service.update(request);
  }
}
