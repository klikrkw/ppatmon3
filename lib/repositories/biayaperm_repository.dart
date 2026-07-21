import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/models/add_biayaperm_request.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/models/rincianbiayaperm.dart';
import 'package:newklikrkw/services/biayaperm_service.dart';

class BiayapermRepository {
  final BiayapermService service;

  BiayapermRepository(this.service);

  Future<List<Biayaperm>> getBiayaperms({
    required int offset,
    required int limit,
    String? transpermohonanId,
    bool isTranspermohonanId = false,
    StatusBiayas? statusBiayaperm,
  }) {
    return service.getBiayaperms(
      offset: offset,
      limit: limit,
      transpermohonanId: transpermohonanId,
      isTranspermohonanId: isTranspermohonanId,
      statusBiayaperm: statusBiayaperm,
    );
  }

  Future<List<Rincianbiayaperm>> getRincianBiayaperm(String transpermohonanId) {
    return service.getRincianBiayaperm(transpermohonanId);
  }

  Future<Biayaperm> getBiayaperm(String biayapermId) {
    return service.getBiayaperm(biayapermId);
  }

  Future<void> addBiayaperm(AddBiayapermRequest request) {
    return service.addBiayaperm(request);
  }

  Future<void> updateBiayaperm(String id, AddBiayapermRequest request) {
    return service.updateBiayaperm(id, request);
  }
}
