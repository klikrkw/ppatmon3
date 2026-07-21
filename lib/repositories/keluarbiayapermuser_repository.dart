import 'package:newklikrkw/models/add_keluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/services/keluarbiayapermuser_service.dart';

class KeluarbiayapermuserRepository {
  final KeluarbiayapermuserService service;

  KeluarbiayapermuserRepository(this.service);

  Future<Map<String, dynamic>> getKeluarbiayapermusers({
    int offset = 0,
    int limit = 20,
    int? userId,
    String? status,
  }) {
    return service.getKeluarbiayapermusers(
      offset: offset,
      limit: limit,
      userId: userId,
      status: status,
    );
  }

  Future<List<User>> getUsers() {
    return service.getUsers();
  }

  Future<List<String>> getStatusKeluarbiayapermusers() {
    return service.getStatusKeluarbiayapermusers();
  }

  Future<void> addKeluarbiayapermuser(AddKeluarbiayapermuserRequest request) {
    return service.addKeluarbiayapermuser(request);
  }

  Future<List<Instansi>> getInstansis({String? kasbonId}) {
    return service.getInstansis(kasbonId: kasbonId);
  }

  Future<List<Metodebayar>> getMetodebayars() {
    return service.getMetodebayars();
  }

  Future<List<Rekening>> getRekenings({int? metodebayarId}) {
    return service.getRekenings(metodebayarId: metodebayarId);
  }

  Future<List<Kasbon>> getKasbons({int? userId}) {
    return service.getKasbons(userId: userId);
  }
}
