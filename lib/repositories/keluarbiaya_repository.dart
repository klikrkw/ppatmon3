import 'package:newklikrkw/models/add_keluarbiaya_request.dart';
import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/services/keluarbiaya_service.dart';

class KeluarbiayaRepository {
  final KeluarbiayaService service;

  KeluarbiayaRepository(this.service);

  Future<Map<String, dynamic>> getKeluarbiayas({
    int offset = 0,
    int limit = 20,
    int? userId,
    String? status,
  }) {
    return service.getKeluarbiayas(
      offset: offset,
      limit: limit,
      userId: userId,
      status: status,
    );
  }

  Future<List<User>> getUsers() {
    return service.getUsers();
  }

  Future<List<String>> getStatusKeluarbiayas() {
    return service.getStatusKeluarbiayas();
  }

  Future<void> addKeluarbiaya(AddKeluarbiayaRequest request) {
    return service.addKeluarbiaya(request);
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
